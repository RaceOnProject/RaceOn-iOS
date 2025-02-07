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

@Reducer
public struct MainFeature {
    @Dependency(\.authUseCase) var authUseCase
    @Dependency(\.friendUseCase) var friendUseCase
    @Dependency(\.timerService) var timerService

    public init() {}
    private enum TimerSubscriptionID: Hashable {}

    public struct State: Equatable {
        public init() {}
        var isReadyForNextScreen: Bool = false
        var selectedMatchingDistance: MatchingDistance = .three
        var selectedCompetitionFreind: Friend?

        var toast: Toast?

        var isShowSheet: Bool = false
        var isAppeard: Bool = false
    }

    public enum Action {
        case onAppear
        case onDisappear
        case startButtonTapped

        case checkFriendList(BaseResponse<FriendResponse>)

        case isPresentedSheet(Bool)
        case selectedCompetitionFreind(Friend?)
        case matchingDistanceSelected(MatchingDistance)

        case registerFCMTokenResponse

        case setErrorMessage(String)

        case showToast(content: String)
        case dismissToast

        // 타이머 관련 액션 추가
        case startTimer
        case stopTimer
        case updateConnectionStatus
        
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
            return .concatenate(
                registerFCMToken(memberId: memberId, fcmToken: fcmToken),
                .send(.startTimer) // 타이머 시작
            )

        case .onDisappear:
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
        case .noAction:
            return .none
        }
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
