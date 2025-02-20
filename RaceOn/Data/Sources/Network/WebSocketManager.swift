//
//  WebSocketManager.swift
//  Data
//
//  Created by ukBook on 1/25/25.
//

import Foundation
import Combine
import SwiftStomp
import Shared

public enum WebSocketStatus {
    case connect
    case disconnect
    case subscribe
    case start
    case process
}

public enum WebSocketMessageType {
    case connect
    case subscribe(gameId: Int)
    case start(gameId: Int, memberId: Int)
    case process(gameId: Int, memberId: Int, time: String, latitude: Double, longitude: Double, distance: Double, avgSpeed: Double, maxSpeed: Double)
    case reject(gameId: Int, memberId: Int)
    case stop(gameId: Int, memberId: Int, requestMemberId: Int, handler: Bool)
}

// MARK: - Process
struct ProcessData: Encodable {
    let time: String
    let latitude: Double
    let longitude: Double
    let distance: Double
    let avgSpeed: Double
    let maxSpeed: Double
}

struct Process: Encodable {
    let command: String
    let data: ProcessData
}

// MARK: - Stop
struct StopData: Encodable {
    let requestMemberId: Int
    let isAgree: Bool
}

struct Stop: Encodable {
    let command: String
    let data: StopData
}

public final class WebSocketManager {
    
    public static let shared = WebSocketManager()
    
    enum Constants {
    #if DEBUG
        static let url: String = "wss://api.runner-dev.shop/ws" // 개발 서버
    #else
        static let url: String = "wss://api.runner-prod.shop/ws" // 운영 서버
    #endif
    }
    
    private var swiftStomp: SwiftStomp?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isConnected = false
    @Published var receivedMessages: [String] = []
    
    let statusSubject = PassthroughSubject<WebSocketStatus, Never>()
    let messageSubject = PassthroughSubject<String, Never>() // 메시지 전송 스트림
    
    public init() {
        setupStompClient()
    }
    
    private func setupStompClient() {
        guard let url = URL(string: Constants.url) else { return }
        swiftStomp = SwiftStomp(host: url)
        swiftStomp?.delegate = self
        
        // ** Subscribe to connection events **
        swiftStomp?.eventsUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case let .connected(type):
                    traceLog("Connected with type: \(type)")
                    self?.isConnected = true
                    self?.statusSubject.send(.connect)
                case let .disconnected(type):
                    traceLog("Disconnected with type: \(type)")
                    self?.isConnected = false
                case let .error(error):
                    traceLog("Error: \(error)")
                }
            }
            .store(in: &cancellables)
        
        // ** Subscribe to messages **
        swiftStomp?.messagesUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                switch message {
                case let .text(message, messageId, destination, _):
                    let formattedMessage = "\(Date().formatted()) [\(destination)] (\(messageId)): \(message)"
//                    traceLog(formattedMessage)
                    self?.receivedMessages.append(formattedMessage)
                    
                case let .data(data, messageId, destination, _):
                    let formattedMessage = "Binary message at `\(destination)`, ID: \(messageId), Size: \(data.count) bytes"
//                    traceLog(formattedMessage)
                    self?.receivedMessages.append(formattedMessage)
                }
            }
            .store(in: &cancellables)
        
        // ** Subscribe to receipt IDs **
        swiftStomp?.receiptUpstream
            .sink { receiptId in
                print("SwiftStomp: Receipt received: \(receiptId)")
            }
            .store(in: &cancellables)
    }
    
    public func sendWebSocketMessage(_ type: WebSocketMessageType) {
        switch type {
        case .connect:
            traceLog(".connect")
            swiftStomp?.connect(acceptVersion: "1.1,1.0", autoReconnect: false)
        case .subscribe(let gameId):
            traceLog(".subscribe")
            let subscriptionId = UUID().uuidString // 고유한 구독 ID 생성
            let destination1 = "/topic/games/\(gameId)"
            
            swiftStomp?.subscribe(
                to: destination1,
                mode: .clientIndividual,
                headers: [
                "id": "sub-\(subscriptionId)"
                ]
            )
            
            let destination2 = "/user/queue/errors"
            
            swiftStomp?.subscribe(
                to: destination2,
                mode: .clientIndividual,
                headers: [
                "id": "sub-\(subscriptionId)"
                ]
            )
            
            self.statusSubject.send(.subscribe)
        case .start(let gameId, let memberId):
            traceLog(".start")
            let destination = "/app/games/\(gameId)/gamer/\(memberId)/start"
            let message = [
                "command": "START",
                "data": "null"
            ]
            
            swiftStomp?.send(body: message, to: destination)
        case .process(let gameId, let memberId, let time, let latitude, let longitude, let distance, let avgSpeed, let maxSpeed):
            traceLog(".process")
            let destination = "/app/games/\(gameId)/gamer/\(memberId)/process"
            let processData = ProcessData(
                    time: time,
                    latitude: latitude,
                    longitude: longitude,
                    distance: distance,
                    avgSpeed: avgSpeed,
                    maxSpeed: maxSpeed
                )

                let message = Process(command: "PROCESS", data: processData)
                print(message)
                swiftStomp?.send(body: message, to: destination)
        case .reject(let gameId, let memberId):
            traceLog(".reject")
            let destination = "/app/games/\(gameId)/gamer/\(memberId)/reject"
            let message = [
                "command": "REJECT INVITATION",
                "data": "null"
            ]
            
            swiftStomp?.send(body: message, to: destination)
        case .stop(let gameId, let memberId, let requestMemberId, let handler):
            traceLog(".stop")
            let destination = "/app/games/\(gameId)/gamer/\(memberId)/stop"
            
            let stopData = StopData(requestMemberId: requestMemberId, isAgree: handler)
            let message = Stop(command: "STOP", data: stopData)
            
            swiftStomp?.send(body: message, to: destination)
        }
    }
    
    public func disconnect() {
        swiftStomp?.disconnect()
    }
}

extension WebSocketManager: SwiftStompDelegate {
    public func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        self.isConnected = true
    }
    
    public func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        self.isConnected = false
    }
    
    public func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String: String]) {
        if let textMessage = message as? String {
            let formattedMessage = "[\(destination)] (\(messageId)): \(textMessage)"
            traceLog(formattedMessage)
            self.messageSubject.send(textMessage)
            self.receivedMessages.append(formattedMessage)
        }
    }
    
    public func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        traceLog("Receipt received: \(receiptId)")
    }
    
    public func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        traceLog("STOMP Error: \(briefDescription)")
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
