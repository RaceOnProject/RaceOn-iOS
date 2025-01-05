//
//  FriendFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import Foundation
import ComposableArchitecture
import CombineSchedulers
import Domain
import Combine

// 타이머 ID 정의 (타이머 취소 시 사용)
struct TimerID: Hashable {}

@Reducer
public struct FriendFeature {
    @Dependency(\.friendUseCase) var friendUsecase
    @Dependency(\.continuousClock) var clock
    
    public init() {}
    
    public struct State: Equatable {
        var friendList: [Friend] = []
        var isActionSheetPresented: Bool = false
        
        var errorMessage: String?
        public init() {}
    }
    
    public enum Action: Equatable {
        case onAppear
        case onDisappear
        case fetchFriendList
        case kebabButtonTapped
        case dismissActionSheet
        
        case setFriendList(friendList: [Friend])
        case setError(error: String)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            // onAppear 시 fetchFriendList를 시작하고, 타이머를 시작(30초 마다 API 호출, Polling 방식)
            return .merge(
                .send(.fetchFriendList),
                .run { send in
                    for await _ in self.clock.timer(interval: .seconds(30)) {
                        await send(.fetchFriendList, animation: .interpolatingSpring)
                    }
                }
                .cancellable(id: TimerID())
            )
        case .onDisappear:
            // 타이머 종료
            return .cancel(id: TimerID())
        case .fetchFriendList:
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
