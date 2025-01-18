//
//  ModalFriendFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 1/16/25.
//

import ComposableArchitecture
import Combine
import Domain

@Reducer
public struct ModalFriendFeature {
    @Dependency(\.friendUseCase) var friendUseCase
    @Dependency(\.continuousClock) var clock
    
    public init() {}
    
    struct TimerID: Hashable {}
    
    public struct State: Equatable {
        init() {}
        
        var friendList: [Friend]?
        var selectedFriend: Friend?
        var competitionButtonEnabled: Bool = false
        
        var isLoading: Bool = false
        var toast: Toast?
    }
    
    public enum Action {
        case onAppear
        case onDisAppear
        
        case fetchFriendList // <- 타이머에서 호출할 액션 추가
        case fetchFriendResponse(BaseResponse<FriendResponse>)
        
        case selectedCompetitionFriend(Friend)
    
        case setErrorMesssage(String)
        
        case showToast(content: String)
        case dismissToast
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            return .merge(
                fetchFriendListEffect(),
                startTimerEffect()
            )
        case .onDisAppear:
            return .cancel(id: TimerID())
        case .fetchFriendList:
            return fetchFriendListEffect()
        case .fetchFriendResponse(let response):
            state.friendList = response.data?.friends
            state.isLoading = false
            return .none
        case .selectedCompetitionFriend(let selectedFriend):
            updateFriendListSelection(&state, selectedFriend: selectedFriend)
            return .none
        case .setErrorMesssage(let errorMessage):
            return .send(.showToast(content: errorMessage))
        case .showToast(let content):
            state.toast = Toast(content: content)
            return .none
        case .dismissToast:
            state.toast = nil
            return .none
        }
    }
    
    private func fetchFriendListEffect() -> Effect<Action> {
        return Effect.publisher {
            friendUseCase.fetchFriendList()
                .map { Action.fetchFriendResponse($0) }
                .catch { error in
                    Just(Action.setErrorMesssage(error.message))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func startTimerEffect() -> Effect<Action> {
        return .run { send in
            for await _ in self.clock.timer(interval: .seconds(30)) {
                await send(.fetchFriendList, animation: .interpolatingSpring)
            }
        }
        .cancellable(id: TimerID())
    }
    
    // 친구 리스트의 선택 상태를 업데이트하는 함수
    private func updateFriendListSelection(_ state: inout State, selectedFriend: Friend) {
        if var friendList = state.friendList,
           let index = friendList.firstIndex(where: { $0.friendId == selectedFriend.friendId }) {
            state.selectedFriend = selectedFriend
            // 모든 친구들의 selected를 false로 설정
            for index in 0..<friendList.count {
                friendList[index].selected = false
            }
            
            // 선택된 친구의 selected를 true로 설정
            friendList[index].selected = true
            
            // 업데이트된 friendList를 state에 반영
            state.friendList = friendList
            state.competitionButtonEnabled = true
        }
    }
}
