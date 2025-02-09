//
//  MatchingProcessFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 1/17/25.
//

import ComposableArchitecture
import Domain
import Combine
import Data
import Shared
import Foundation

@Reducer
public struct MatchingProcessFeature {
    @Dependency(\.gameUseCase) var gameUseCase
    @Dependency(\.webSocketClient) var webSocketClient
    @Dependency(\.continuousClock) var clock
    
    public init() {}
    
    public struct State: Equatable {
        var distance: MatchingDistance
        var friendId: Int
        var isInvited: Bool
        var gameId: Int?
        
        var process: MatchingProcess = .waiting
        
        var toast: Toast?
        
        var webSocketDisconnect: Bool = false
        
        var isReadyForNextScreen: Bool = false
        
        public init(distance: MatchingDistance, friendId: Int, isInvited: Bool, gameId: Int?) {
            self.distance = distance
            self.friendId = friendId
            self.isInvited = isInvited
            self.gameId = gameId
        }
    }
    
    public enum Action {
        case onAppear
        case onDisappear
        case setMatcingProcess(MatchingProcess)
        case setReadyForNextScreen(handler: Bool)
        case inviteGameResponse(BaseResponse<GameInviteResponse>)
        case receiveMessage(String)
        case setWebSocketStatus(WebSocketStatus)
        case setErrorMessage(String)
        case showToast(content: String)
        case backButtonTapped
        case dismissToast
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            let friend = state.friendId
            let distance = state.distance.distance
            let timeLimit = state.distance.timeLimit
            
            if state.isInvited {
                guard let gameId = state.gameId,
                      let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { return .none }
                return .merge(
                    .run { _ in
                        webSocketClient.sendWebSocketMessage(.start(gameId: gameId, memberId: memberId))
                    },
                    webSocketUpdatesPublisher()
                )
            } else {
                return .merge(
                    webSocketUpdatesPublisher(),
                    inviteGame(friendId: friend, distance: distance, timeLimit: timeLimit)
                )
            }
        case .onDisappear:
            return .cancel(id: "WebSocketUpdatesPublisher")
        case .setMatcingProcess(let process):
            state.process = process
            process.isFailed ? webSocketClient.disconnect() : nil
            return .none
        case .setReadyForNextScreen(let handler):
            state.isReadyForNextScreen = handler
            return .none
        case .inviteGameResponse(let response):
            guard let gameId = response.data?.gameInfo.gameId else {
                return .send(.setMatcingProcess(.failed(reason: response.message)))
            }
            
            state.gameId = gameId
            
            if response.success {
                return .run { _ in
                    webSocketClient.sendWebSocketMessage(.connect)
                }
            } else {
                return .send(.setMatcingProcess(.failed(reason: response.message)))
            }
        case .receiveMessage(let message):
            traceLog("🏆 receiveMessage \(message)")
            if let gameMessage = parseGameMessage(from: message) {
                if gameMessage.statusCode >= 200 && gameMessage.statusCode < 300 {
                    if gameMessage.data?.startTime != nil { // 경쟁상대 대기 상태
                        return .run { send in
                            for index in (0...3).reversed() {
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                await send(.setMatcingProcess(.successed(seconds: index)))
                            }
                            
                            await send(.setReadyForNextScreen(handler: true))
                        }
                    }
                } else {
                    return .send(.setMatcingProcess(.failed(reason: gameMessage.message)))
                }
            } else if let rejectMessage = parseRejectMessage(from: message) {
                return .send(.setMatcingProcess(.failed(reason: "친구의 거절로 매칭이 실패했어요")))
            } else {
                return .send(.setMatcingProcess(.failed(reason: "Client Error(Decoding Failed)")))
            }
            return .none
        case .setWebSocketStatus(let status):
            print("🏆 웹 소켓 Status \(status)")
            switch status {
            case .connect:
                guard let gameId = state.gameId else { return .none }
                webSocketClient.sendWebSocketMessage(.subsribe(gameId: gameId))
            case .subscribe:
                guard let gameId = state.gameId,
                      let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { break }
                webSocketClient.sendWebSocketMessage(.start(gameId: gameId, memberId: memberId))
            default:
                break
            }
            return .none
        case .setErrorMessage(let errorMessage):
            return .send(.showToast(content: errorMessage))
        case .showToast(let content):
            state.toast = Toast(content: content)
            return .none
        case .backButtonTapped:
            webSocketClient.disconnect()
            return .none
        case .dismissToast:
            state.toast = nil
            return .none
        }
    }
    
    private func inviteGame(friendId: Int, distance: Double, timeLimit: Int) -> Effect<Action> {
        return Effect.publisher {
            gameUseCase.inviteGame(friendId: friendId, distance: distance, timeLimit: timeLimit)
                .map {
                    Action.inviteGameResponse($0)
                }
                .catch { error in
                    Just(Action.setErrorMessage(error.message))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func webSocketUpdatesPublisher() -> Effect<Action> {
        return Effect.merge(
            Effect.publisher {
                webSocketClient.messagePublisher()
                    .map {
                        print("🏆 MessagePublisher Action 생성: \($0)")
                        return Action.receiveMessage($0)
                    }
            },
            Effect.publisher {
                webSocketClient.statusPublisher()
                    .map {
                        print("🏆 StatusPublisher Action 생성: \($0)") // Action 생성 확인
                        return Action.setWebSocketStatus($0)
                    }
            }
        )
        .cancellable(id: "WebSocketUpdatesPublisher", cancelInFlight: true)
    }
    
    // JSON을 Swift 객체로 변환
    func parseGameMessage(from stompMessage: String) -> GameMessage? {
        guard let jsonData = stompMessage.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decodedMessage = try JSONDecoder().decode(GameMessage.self, from: jsonData)
            return decodedMessage
        } catch {
            print("JSON 디코딩 실패: \(error)")
            return nil
        }
    }

    // JSON을 Swift 객체로 변환
    func parseRejectMessage(from stompMessage: String) -> RejectMessage? {
        guard let jsonData = stompMessage.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decodedMessage = try JSONDecoder().decode(RejectMessage.self, from: jsonData)
            return decodedMessage
        } catch {
            print("JSON 디코딩 실패: \(error)")
            return nil
        }
    }
}
