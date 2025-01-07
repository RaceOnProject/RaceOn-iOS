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
        public init() {}
        
        var toast: Toast?
        var friendList: [Friend]?
        var isActionSheetPresented: Bool = false
        
        var selectFriend: Friend?
        
        var errorMessage: String?
    }
    
    public enum Action: Equatable {
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
        
        case resultReportFriend(response: BaseResponse)
        case resultUnFriend(response: BaseResponse)
        
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
        case .kebabButtonTapped(let friend):
            state.selectFriend = friend
            state.isActionSheetPresented = true
            return .none
        case .dismissActionSheet:
            // ActionSheet dismiss 처리
            state.isActionSheetPresented = false
            return .none
            
        case .reportFriend(let friend):
            return Effect.publisher {
                friendUsecase.reportFriend(memberId: friend.friendId)
                    .receive(on: DispatchQueue.main)
                    .map { Action.resultReportFriend(response: $0) }
                    .catch { Just(Action.setError(error: $0.localizedDescription)) }
                    .eraseToAnyPublisher()
            }
        case .unfriend(let friend):
            return Effect.publisher {
                friendUsecase.unFriend(memberId: friend.friendId)
                    .receive(on: DispatchQueue.main)
                    .map { Action.resultUnFriend(response: $0) }
                    .catch { Just(Action.setError(error: $0.localizedDescription)) }
                    .eraseToAnyPublisher()
            }
        case .cancelButtonTapped:
            state.selectFriend = nil
            return .none
            
        case .dismissToast:
            state.toast = nil
            return .none
        case .resultReportFriend(let response):
            state.toast = Toast(content: "신고 완료")
            return .send(.fetchFriendList)
        case .resultUnFriend(let response):
            state.toast = Toast(content: "친구 끊기 완료")
            return .send(.fetchFriendList)
        case .setFriendList(let friendList):
            state.friendList = friendList
            return .none
        case .setError(let errorMessage):
            state.errorMessage = errorMessage
            return .none
        }
    }
}
