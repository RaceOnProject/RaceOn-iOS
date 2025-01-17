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

@Reducer
public struct FriendFeature {
    @Dependency(\.friendUseCase) var friendUsecase
    @Dependency(\.continuousClock) var clock
    
    public init() {}
    
    struct TimerID: Hashable {}
    
    public struct State: Equatable {
        public init() {}
        
        var toast: Toast?
        var friendList: [Friend]?
        var isActionSheetPresented: Bool = false
        
        var selectFriend: Friend?
        
        var isLoading: Bool = false
        var errorMessage: String?
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
        case dismissToast
        
        case resultReportFriend(response: BaseResponse<VoidResponse>)
        case resultUnFriend(response: BaseResponse<VoidResponse>)
        
        case setFriendList(friendList: [Friend])
        case setErrorMessage(String)
        
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            // onAppear 시 fetchFriendList를 시작하고, 타이머를 시작(30초 마다 API 호출, Polling 방식)
            state.isLoading = true
            
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
                    .map {
                        if let data = $0.data {
                            return Action.setFriendList(friendList: data.friends)
                        } else {
                            return Action.setErrorMessage("친구 목록을 찾을 수 없습니다.")
                        }
                    }
                    .catch { error -> Just<Action> in
                        // 에러를 처리하여 Action.setError로 반환
                        let errorMessage = error.message
                        return Just(Action.setErrorMessage(errorMessage))
                    }
                    .eraseToAnyPublisher()
            }
        case .kebabButtonTapped(let friend):
            state.selectFriend = friend
            state.isActionSheetPresented = true
            return .none
        case .dismissActionSheet:
            // ActionSheet dismiss 처리
            state.isActionSheetPresented = false
            return .none
            
        case .reportFriend(let friend):
            state.isLoading = true
            
            return Effect.publisher {
                friendUsecase.reportFriend(memberId: friend.friendId)
                    .receive(on: DispatchQueue.main)
                    .map {
                        Action.resultReportFriend(response: $0)
                    }
                    .catch { error -> Just<Action> in
                        // 에러를 처리하여 Action.setError로 반환
                        let errorMessage = error.message
                        return Just(Action.setErrorMessage(errorMessage))
                    }
                    .eraseToAnyPublisher()
            }
        case .unfriend(let friend):
            state.isLoading = true
            
            return Effect.publisher {
                friendUsecase.unFriend(memberId: friend.friendId)
                    .receive(on: DispatchQueue.main)
                    .map {
                        Action.resultUnFriend(response: $0)
                    }
                    .catch { error -> Just<Action> in
                        // 에러를 처리하여 Action.setError로 반환
                        let errorMessage = error.message
                        return Just(Action.setErrorMessage(errorMessage))
                    }
                    .eraseToAnyPublisher()
            }
        case .cancelButtonTapped:
            state.selectFriend = nil
            return .none
            
        case .dismissToast:
            state.toast = nil
            return .none
        case .resultReportFriend(let response):
            state.isLoading = false
            state.toast = Toast(content: "신고 완료")
            return .send(.fetchFriendList)
        case .resultUnFriend(let response):
            state.isLoading = false
            state.toast = Toast(content: "친구 끊기 완료")
            return .send(.fetchFriendList)
        case .setFriendList(let friendList):
            state.isLoading = false
            state.friendList = friendList
            return .none
        case .setErrorMessage(let errorMessage):
            state.isLoading = false
            state.errorMessage = errorMessage
            return .none
        }
    }
}
