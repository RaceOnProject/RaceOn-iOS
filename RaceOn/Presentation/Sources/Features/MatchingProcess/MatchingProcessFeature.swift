//
//  MatchingProcessFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 1/17/25.
//

import ComposableArchitecture
import Domain
import Combine

@Reducer
public struct MatchingProcessFeature {
    @Dependency(\.gameUseCase) var gameUseCase
    
    public init() {}
    
    public struct State: Equatable {
        var distance: MatchingDistance
        var friend: Friend
        
        var process: MatchingProcess = .waiting
        
        var errorMessage: String?
        
        public init(distance: MatchingDistance, friend: Friend) {
            self.distance = distance
            self.friend = friend
        }
    }
    
    public enum Action {
        case onAppear
        case inviteGameResponse(BaseResponse<GameInviteResponse>)
        case setErrorMessage(String)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            let friend = state.friend.friendId
            let distance = state.distance.distance
            let timeLimit = state.distance.timeLimit
            
            return inviteGame(friendId: friend, distance: distance, timeLimit: timeLimit)
        case .inviteGameResponse(let response):
            print(response)
            return .none
        case .setErrorMessage(let errorMessage):
            state.errorMessage = errorMessage
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
}
