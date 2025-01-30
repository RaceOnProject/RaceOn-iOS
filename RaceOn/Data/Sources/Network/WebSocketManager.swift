//
//  WebSocketManager.swift
//  Data
//
//  Created by ukBook on 1/25/25.
//

import Foundation
import Combine

public enum WebSocketStatus {
    case connect
    case disconnect
    case subscribe
    case start
    case process
}

public final class WebSocketManager: NSObject {
    // WebSocket URL 설정
    enum Constants {
    #if DEBUG
        static let url: String = "wss://api.runner-dev.shop/ws" // 개발 서버
    #else
        static let url: String = "wss://api.runner-prod.shop/ws" // 운영 서버
    #endif
    }
    
    private var retryCount = 0
    private let maxRetryCount = 5
    
    public static let shared = WebSocketManager()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    public var statusSubject = PassthroughSubject<WebSocketStatus, Never>()
    public var messageSubject = PassthroughSubject<String, Never>() // 메시지 전송 스트림
    
    public override init() {
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        super.init()
    }
    
    // WebSocket 연결
    public func connect(to gameId: Int, memberId: Int) {
        guard let url = URL(string: Constants.url) else {
            print("Invalid URL")
            return
        }
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        print("WebSocket connected to \(url)")
        
        statusSubject.send(.connect)
        
        listenForMessages()
        connect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.subscribe(to: gameId)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.start(to: gameId, memberId: memberId)
        }
    }
    
    // WebSocket 연결 종료
    public func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("WebSocket disconnected")
        statusSubject.send(.disconnect)
    }
    
    // 메시지 수신
    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
                
                // 에러 처리 로직
                self.retryCount += 1
                if self.retryCount <= self.maxRetryCount {
                    print("Retrying to connect (\(self.retryCount)/\(self.maxRetryCount))")
                    self.listenForMessages()
                } else {
                    print("Max retry attempts reached. Disconnecting.")
                    self.disconnect()
                }
                
            case .success(let message):
                self.retryCount = 0 // 성공하면 재시도 횟수 초기화
                switch message {
                case .string(let text):
                    print("receiveMessage \(text)")
                    self.messageSubject.send(text) // 메시지를 스트림에 추가
                case .data(let data):
                    print("Received binary data: \(data)")
                @unknown default:
                    print("Received unknown type")
                }
                
                // 메시지 수신을 계속 시도
                self.listenForMessages()
            }
        }
    }

    // 메시지 전송
    public func sendMessage(_ message: String) {
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print("Failed to send message: \(error)")
            } else {
                print("Message sent: \(message)")
            }
        }
    }
    
    // STOMP SUBSCRIBE 프레임 생성 및 전송
    public func connect() {
        let connectFrame = """
        CONNECT
        accept-version:1.1,1.0
        heart-beat:10000,10000
        
        \0
        """
        
        sendMessage(connectFrame)
    }
    
    // STOMP SUBSCRIBE 프레임 생성 및 전송
    public func subscribe(to gameId: Int) {
        let subscriptionId = "sub-" + UUID().uuidString
        let destination = "/topic/games/\(gameId)"
        
        let subscribeFrame = """
        SUBSCRIBE
        id:\(subscriptionId)
        destination:\(destination)

        \0
        """
        
        sendMessage(subscribeFrame)
    }
    
    public func start(to gameId: Int, memberId: Int) {
        let destination = "/app/games/\(gameId)/gamer/\(memberId)"
        let startFrame = """
        SEND
        destination:\(destination)
        {"command":"START", "data": null}
        
        \0
        """
        
        sendMessage(startFrame)
    }
    
    public func statusPublisher() -> AnyPublisher<WebSocketStatus, Never> {
        return statusSubject.eraseToAnyPublisher()
    }
    
    public func messagePublisher() -> AnyPublisher<String, Never> {
        return messageSubject.eraseToAnyPublisher()
    }
}
