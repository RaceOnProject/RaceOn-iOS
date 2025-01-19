//
//  FriendRepositoryProtocol.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

import Combine

public protocol FriendRepositoryProtocol {
    func sendFriendCode(_ code: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
    func fetchFriendList() -> AnyPublisher<BaseResponse<FriendResponse>, NetworkError>
    func reportFriend(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
    func unFriend(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
    func updateConnectionStatus() -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
}
