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

@Reducer
public struct FriendFeature {
    @Dependency(\.friendUseCase) var friendUsecase
    @Dependency(\.continuousClock) var clock
    
    public init() {}

    // 타이머 ID 정의 (타이머 취소 시 사용)
    struct TimerID: Hashable {}
    
    public struct State: Equatable {
        public init() {}
        
        var toast: Toast?
        var friendList: [Friend]?
        var isActionSheetPresented: Bool = false
        
        var selectFriend: Friend?
        
        var isLoading: Bool = false
    }
    
    public enum Action {
        case onAppear
        case onDisappear
        case fetchFriendList
        case kebabButtonTapped(friend: Friend)
        
        // Alert
        case dismissActionSheet
        case reportFriend(friend: Friend) // 신고하기
        case unfriend(friend: Friend)    // 친구끊기
        case cancelButtonTapped // 취소하기
        
        // Toast
        case showToast(content: String)
        case dismissToast
        
        case resultReportFriend(response: BaseResponse<VoidResponse>)
        case resultUnFriend(response: BaseResponse<VoidResponse>)
        
        case setFriendList(friendList: [Friend])
        case setErrorMessage(String)
    }
    
    // MARK: - Helper Methods
    
    // 타이머 시작
    private func startPollingTimer() -> Effect<Action> {
        return .run { send in
            for await _ in self.clock.timer(interval: .seconds(30)) {
                await send(.fetchFriendList, animation: .interpolatingSpring)
            }
        }
        .cancellable(id: TimerID())
    }
    
    // 타이머 종료
    private func stopPollingTimer() -> Effect<Action> {
        return .cancel(id: TimerID())
    }
    
    // 친구 목록을 가져오는 서버 요청
    private func fetchFriendListEffect() -> Effect<Action> {
        return Effect.publisher {
            friendUsecase.fetchFriendList()
                .receive(on: DispatchQueue.main)
                .map {
                    if let data = $0.data {
                        return Action.setFriendList(friendList: data.friends)
                    } else {
                        return Action.setErrorMessage("친구 목록을 찾을 수 없습니다.")
                    }
                }
                .catch { error -> Just<Action> in
                    let errorMessage = error.message
                    return Just(Action.setErrorMessage(errorMessage))
                }
                .eraseToAnyPublisher()
        }
    }
    
    // 친구 신고 서버 요청
    private func reportFriendEffect(friend: Friend) -> Effect<Action> {
        return Effect.publisher {
            friendUsecase.reportFriend(memberId: friend.friendId)
                .receive(on: DispatchQueue.main)
                .map {
                    Action.resultReportFriend(response: $0)
                }
                .catch { error -> Just<Action> in
                    let errorMessage = error.message
                    return Just(Action.setErrorMessage(errorMessage))
                }
                .eraseToAnyPublisher()
        }
    }
    
    // 친구 끊기 서버 요청
    private func unfriendEffect(friend: Friend) -> Effect<Action> {
        return Effect.publisher {
            friendUsecase.unFriend(memberId: friend.friendId)
                .receive(on: DispatchQueue.main)
                .map {
                    Action.resultUnFriend(response: $0)
                }
                .catch { error -> Just<Action> in
                    let errorMessage = error.message
                    return Just(Action.setErrorMessage(errorMessage))
                }
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Reducer
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            return .merge(
                .send(.fetchFriendList),
                startPollingTimer()  // 타이머 시작
            )
        
        case .onDisappear:
            // 타이머 종료
            return stopPollingTimer()
        
        case .fetchFriendList:
            return fetchFriendListEffect()
        
        case .kebabButtonTapped(let friend):
            state.selectFriend = friend
            state.isActionSheetPresented = true
            return .none
        
        case .reportFriend(let friend):
            state.isLoading = true
            return reportFriendEffect(friend: friend)
        
        case .unfriend(let friend):
            state.isLoading = true
            return unfriendEffect(friend: friend)
        
        case .cancelButtonTapped:
            state.selectFriend = nil
            return .none
        
        case .dismissActionSheet:
            state.isActionSheetPresented = false
            return .none
        
        case .showToast(let content):
            state.toast = Toast(content: content)
            return .none
        case .dismissToast:
            state.toast = nil
            return .none
        
        case .resultReportFriend(let response):
            state.isLoading = false
            return .send(.showToast(content: "신고 완료"))
        case .resultUnFriend(let response):
            state.isLoading = false
            return .concatenate(
                .send(.showToast(content: "친구 끊기 완료")),
                .send(.fetchFriendList)
            )
        case .setFriendList(let friendList):
            state.isLoading = false
            state.friendList = friendList
            return .none
        
        case .setErrorMessage(let errorMessage):
            state.isLoading = false
            return .send(.showToast(content: errorMessage))
        }
    }
}
