//
//  MainFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 1/16/25.
//

import ComposableArchitecture
import Combine
import Shared
import Domain
import Data

@Reducer
public struct MainFeature {
    @Dependency(\.authUseCase) var authUseCase
    @Dependency(\.friendUseCase) var friendUseCase
    @Dependency(\.timerService) var timerService
    @Dependency(\.webSocketClient) var webSocketClient

    public init() {}
    private enum TimerSubscriptionID: Hashable {}

    public struct State: Equatable {
        public init() {}
        var isReadyForNextScreen: Bool = false
        var selectedMatchingDistance: MatchingDistance = .three
        var selectedCompetitionFreind: Friend?
        
        var isInvited: Bool = false
        
        var friendId: Int?
        var gameId: Int?

        var toast: Toast?
        
        var pushNotificationData: PushNotificationData?
        var isPresentedCustomAlert: Bool = false

        var isShowSheet: Bool = false
        var isAppeard: Bool = false
    }

    public enum Action {
        case onAppear
        case onDisappear
        case setIsReadForNextScreen
        case startButtonTapped

        case checkFriendList(BaseResponse<FriendResponse>)

        case isPresentedSheet(Bool)
        case selectedCompetitionFreind(Friend?)
        case matchingDistanceSelected(MatchingDistance)

        case registerFCMTokenResponse

        case setErrorMessage(String)

        case showToast(content: String)
        case dismissToast
        
        case receivePushNotificationData(PushNotificationData)
        
        case presentCustomAlert
        case dismissCustomAlert

        // 타이머 관련 액션 추가
        case startTimer
        case stopTimer
        case updateConnectionStatus
        
        // 웹소켓 관련 Action
        case receiveMessage(String)
        case setWebSocketStatus(WebSocketStatus)
        
        case noAction
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            guard !state.isAppeard,
                  let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId),
                  let fcmToken: String = UserDefaultsManager.shared.get(forKey: .FCMToken) else {
                return .none
            }
            
            state.isAppeard = true
            return .merge(
                registerFCMToken(memberId: memberId, fcmToken: fcmToken),
                .send(.startTimer) // 타이머 시작
            )
        case .onDisappear:
            return .cancel(id: "WebSocketUpdatesPublisher")
        case .setIsReadForNextScreen:
            state.isReadyForNextScreen = false
            return .none
        case .startButtonTapped:
            return checkFriendList()

        case .checkFriendList(let response):
            print("🔥 \(response)")
            guard let friends = response.data?.friends else {
                return .send(.setErrorMessage("친구 목록 불러오기 오류"))
            }

            return .send(friends.isEmpty ? .setErrorMessage("경쟁할 친구가 없어요") : .isPresentedSheet(true))

        case .isPresentedSheet(let handler):
            state.isShowSheet = handler
            return .none

        case .selectedCompetitionFreind(let friend):
            state.selectedCompetitionFreind = friend
            state.friendId = friend?.friendId
            state.isReadyForNextScreen = true
            return .none

        case .matchingDistanceSelected(let distance):
            state.selectedMatchingDistance = distance
            return .none
        case .registerFCMTokenResponse:
            print("토큰 적재 성공")
            return .none
        case .setErrorMessage(let errorMessage):
            print("토큰 적재 실패")
            return .send(.showToast(content: errorMessage))
        case .showToast(let content):
            state.toast = Toast(content: content)
            return .none
        case .dismissToast:
            state.toast = nil
            return .none

        case .receivePushNotificationData(let data):
            
            state.isPresentedCustomAlert = true
            state.pushNotificationData = data
            state.gameId = Int(state.pushNotificationData?.gameId ?? "0")
            state.friendId = Int(state.pushNotificationData?.requestMemberId ?? "0")
            
            guard let gameId = Int(state.pushNotificationData?.gameId ?? "0") else { return .none }
                    
            return .concatenate(
                .run { _ in
                    webSocketClient.sendWebSocketMessage(.connect)
                },
                webSocketUpdatesPublisher()
            )
        case .presentCustomAlert:
            state.isPresentedCustomAlert = false
            state.isInvited = true
            let distance = state.pushNotificationData?.distance ?? "3.0"
            
            switch distance {
            case "3.0": state.selectedMatchingDistance = .three
            case "5.0": state.selectedMatchingDistance = .five
            case "10.0": state.selectedMatchingDistance = .ten
            default: break
            }
            
            state.isReadyForNextScreen = true
            return .none
        case .dismissCustomAlert:
            guard let gameId = state.gameId,
                  let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { return .none }
            state.isPresentedCustomAlert = false
            return .concatenate(
                Effect.run { _ in
                    webSocketClient.sendWebSocketMessage(.reject(gameId: gameId, memberId: memberId))
                },
                Effect.run { _ in
                    webSocketClient.disconnect()
                }
            )
        // 타이머 관련 액션 처리
        case .startTimer:
            return .merge(
            .run { _ in
                timerService.start()
            },
            Effect.publisher {
                timerService.currentTimePublisher()
                    .map { .updateConnectionStatus }
                    .eraseToAnyPublisher()
            }
        )
        case .stopTimer:
            timerService.stop()
            return .none

        case .updateConnectionStatus:
            return updateConnectionStatus()
            
        case .receiveMessage(let message):
            traceLog("🏆 receiveMessage \(message)")
            return .none
        case .setWebSocketStatus(let status):
            traceLog("🏆 웹 소켓 Status \(status)")
            switch status {
            case .connect:
                guard let gameId = state.gameId else { return .none }
                webSocketClient.sendWebSocketMessage(.subsribe(gameId: gameId))
            default:
                break
            }
            return .none
        case .noAction:
            return .none
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
    
    private func updateConnectionStatus() -> Effect<Action> {
        return Effect.publisher {
            friendUseCase.updateConnectionStatus()
                .map { _ in
                    return Action.noAction
                }
                .catch { _ in
                    return Just(Action.stopTimer)
                }
                .eraseToAnyPublisher()
        }
    }

    private func registerFCMToken(memberId: Int, fcmToken: String) -> Effect<Action> {
        return Effect.publisher {
            authUseCase.registerFCMToken(memberId: memberId, fcmToken: fcmToken)
                .map { _ in
                    Action.registerFCMTokenResponse
                }
                .catch { error in
                    Just(Action.setErrorMessage(error.message))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func checkFriendList() -> Effect<Action> {
        return Effect.publisher {
            friendUseCase.fetchFriendList()
                .map {
                    Action.checkFriendList($0)
                }
                .catch { error in
                    Just(Action.setErrorMessage(error.message))
                }
                .eraseToAnyPublisher()
        }
    }
}
