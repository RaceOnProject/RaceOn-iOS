//
//  FriendFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import Foundation
import ComposableArchitecture
import Domain
import Combine

@Reducer
public struct FriendFeature {
    @Dependency(\.friendUseCase) var friendUsecase
    
    public init() {}
    
    public struct State: Equatable {
        var friendList: [Friend] = []
        var isActionSheetPresented: Bool = false
        
        var errorMessage: String?
        public init() {}
    }
    
    public enum Action: Equatable {
        case onAppear
        case kebabButtonTapped
        case dismissActionSheet
        
        case setFriendList(friendList: [Friend])
        case setError(error: String)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return Effect.publisher {
                friendUsecase.fetchFriendList()
                    .receive(on: DispatchQueue.main)
                    .map { Action.setFriendList(friendList: $0.data.friends) }
                    .catch { Just(Action.setError(error: $0.localizedDescription)) }
                    .eraseToAnyPublisher()
            }
        case .kebabButtonTapped:
            print("FriendFeature kebabButtonTapped")
            state.isActionSheetPresented = true
            return .none
        case .dismissActionSheet:
            // ActionSheet dismiss 처리
            state.isActionSheetPresented = false
            return .none
            
        case .setFriendList(let friendList):
            state.friendList = friendList
            return .none
        case .setError(let errorMessage):
            state.errorMessage = errorMessage
            return .none
        }
    }
}
