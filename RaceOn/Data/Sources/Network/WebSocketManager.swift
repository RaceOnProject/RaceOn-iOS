//
//  WebSocketManager.swift
//  Data
//
//  Created by ukBook on 1/25/25.
//

import Foundation
import Combine
import Starscream

public enum WebSocketStatus {
    case connect
    case disconnect
    case subscribe
    case start
    case process
}

public final class WebSocketManager: WebSocketDelegate {
    
    public static let shared = WebSocketManager()
    
    enum Constants {
    #if DEBUG
        static let url: String = "wss://api.runner-dev.shop/ws" // 개발 서버
    #else
        static let url: String = "wss://api.runner-prod.shop/ws" // 운영 서버
    #endif
    }
    
    var socket: WebSocket?
    let statusSubject = PassthroughSubject<WebSocketStatus, Never>()
    let messageSubject = PassthroughSubject<String, Never>() // 메시지 전송 스트림
    
    public init() {
        var request = URLRequest(url: URL(string: Constants.url)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
    }
    
    public func connect() {
        socket?.connect()
    }
    
    public func disconnect() {
        socket?.disconnect()
    }
    
    public func sendMessage(_ message: String) {
        socket?.write(string: message)
        print("🏆 WebSocket 으로 보낸 메시지 \(message)")
    }
    
    // MARK: - WebSocketDelegate Methods
    public func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("🏆 WebSocket 연결됨: \(headers)")
            statusSubject.send(.connect)
        case .disconnected(let reason, let code):
            print("🏆 WebSocket 연결 해제됨: \(reason) (코드: \(code))")
        case .text(let text):
            messageSubject.send(text)
            print("🏆 WebSocket 받은 메시지: \(text)")
        case .binary(let data):
            print("🏆 WebSocket 받은 바이너리 데이터: \(data)")
        case .pong(_):
            print("🏆 WebSocket Pong 수신")
        case .ping:
            print("🏆 WebSocket Ping 송신")
        case .error(let error):
            print("🏆 WebSocket 오류 발생: \(String(describing: error))")
        case .cancelled:
            print("🏆 WebSocket 연결 취소됨")
        case .viabilityChanged(_), .reconnectSuggested(_):
            break
        case .peerClosed:
            break
        }
    }
}

extension WebSocketManager {
    // STOMP SUBSCRIBE 프레임 생성 및 전송
    public func sendConnect() {
        let connectFrame = """
        CONNECT
        accept-version:1.1,1.0
        heart-beat:10000,10000
        
        \0
        """
        
        sendMessage(connectFrame)
        statusSubject.send(.subscribe)
    }
    
    // STOMP SUBSCRIBE 프레임 생성 및 전송
    public func sendSubscribe(to gameId: Int) {
        let subscriptionId = "sub-" + UUID().uuidString
        let destination = "/topic/games/\(gameId)"
        
        let subscribeFrame = """
        SUBSCRIBE
        id:\(subscriptionId)
        destination:\(destination)

        \0
        """
        
        sendMessage(subscribeFrame)
        statusSubject.send(.start)
    }
    
    public func sendStart(to gameId: Int, memberId: Int) {
        let destination = "/app/games/\(gameId)/gamer/\(memberId)"
        let startFrame = """
        SEND
        destination:\(destination)
        {"command":"START", "data": null}
        
        \0
        """
        
        sendMessage(startFrame)
    }
}

extension WebSocketManager {
    public func statusPublisher() -> AnyPublisher<WebSocketStatus, Never> {
        return statusSubject.eraseToAnyPublisher()
    }
    
    public func messagePublisher() -> AnyPublisher<String, Never> {
        return messageSubject.eraseToAnyPublisher()
    }
}
