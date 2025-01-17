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
    
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        var isReadyForNextScreen: Bool = false
        var selectedMatchingDistance: MatchingDistance = .three
        var selectedCompetitionFreind: Friend?
        
        var errorMessage: String?
        var isShowSheet: Bool = false
    }
    
    public enum Action {
        case onAppear
        case onDisappear
        case startButtonTapped
        case dismissSheet
        case selectedCompetitionFreind(Friend?)
        case matchingDistanceSelected(MatchingDistance)
        
        case registerFCMTokenResponse
        
        case setErrorMessage(String)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId),
                  let fcmToken: String = UserDefaultsManager.shared.get(forKey: .FCMToken) else {
                return .none
            }
            return registerFCMToken(memberId: memberId, fcmToken: fcmToken)
        case .onDisappear:
            state.isReadyForNextScreen = false
            return .none
        case .startButtonTapped:
            state.isShowSheet = true
            return .none
        case .dismissSheet:
            state.isShowSheet = false
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
            state.errorMessage = errorMessage
            return .none
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
}
