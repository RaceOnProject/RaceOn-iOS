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
    
    public init() {}
    
    public struct State: Equatable {
        var distance: MatchingDistance
        var friendId: Int
        var gameId: Int?
        
        var process: MatchingProcess = .waiting
        
        var toast: Toast?
        
        var webSocketDisconnect: Bool = false
        
        public init(distance: MatchingDistance, friendId: Int) {
            self.distance = distance
            self.friendId = friendId
        }
    }
    
    public enum Action {
        case onAppear
        case inviteGameResponse(BaseResponse<GameInviteResponse>)
        case receiveMessage(String)
        case setWebSocketStatus(WebSocketStatus)
        case setErrorMessage(String)
        case showToast(content: String)
        case dismissToast
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            let friend = state.friendId
            let distance = state.distance.distance
            let timeLimit = state.distance.timeLimit
            
            return Effect.merge(
                webSocketUpdatesPublisher(),
                inviteGame(friendId: friend, distance: distance, timeLimit: timeLimit)
            )
        case .inviteGameResponse(let response):
            guard let gameId = response.data?.gameInfo.gameId,
                  let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else {
                return .none
            }
            
            state.gameId = gameId
            
            webSocketClient.connect()
            return .none
        case .receiveMessage(let message):
            print("🏆 receiveMessage \(message)")
            
            if message.starts(with: "CONNECTED") {
                print("🟢 CONNECTED 메시지 수신")
            } else if message.starts(with: "MESSAGE") {
                print("🔴 MESSAGE 메시지 수신")
            } else {
                print("⚠️ 기타 메시지 수신")
            }
            // Swift 객체로 변환
//            if let parsedMessage = parseGameMessage(from: message) {
//                print("디코딩 성공: \(parsedMessage)")
//            } else {
//                print("디코딩 실패")
//            }
            return .none
        case .setWebSocketStatus(let status):
            print("🏆 웹 소켓 Status \(status)")
            switch status {
            case .connect:
                webSocketClient.sendConnect()
            case .disconnect:
                state.webSocketDisconnect = true
            case .subscribe:
                guard let gameId = state.gameId else { break }
                webSocketClient.sendSubscribe(to: gameId)
            case .start:
                guard let gameId = state.gameId,
                      let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { break }
                webSocketClient.sendStart(to: gameId, memberId: memberId)
            default:
                break
            }
            return .none
        case .setErrorMessage(let errorMessage):
            return .send(.showToast(content: errorMessage))
        case .showToast(let content):
            state.toast = Toast(content: content)
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
                        print("🏆 type => \(type(of: $0))")
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
    }
    
    // STOMP 메시지에서 JSON 추출
    func extractJSON(from stompMessage: String) -> String? {
        let components = stompMessage.components(separatedBy: "\n\n")
        
        // JSON 데이터가 있는지 확인
        guard components.count > 1 else {
            print("JSON 데이터가 없습니다.")
            return nil
        }
        
        // 마지막 부분이 JSON 데이터 (NULL 문자 제거)
        let jsonString = components.last?.trimmingCharacters(in: .controlCharacters)
        return jsonString
    }

    // JSON을 Swift 객체로 변환
    func parseGameMessage(from stompMessage: String) -> GameMessage? {
        guard let jsonString = extractJSON(from: stompMessage),
              let jsonData = jsonString.data(using: .utf8) else {
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

}
