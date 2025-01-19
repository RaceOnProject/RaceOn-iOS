//
//  FriendRepositoryImpl.swift
//  Data
//
//  Created by ukseung.dev on 1/2/25.
//

import Moya
import Domain
import ComposableArchitecture
import Foundation
import Combine
import Alamofire

public final class FriendRepositoryImpl: FriendRepositoryProtocol {
    public init() {}
    private let networkManager: NetworkManager = NetworkManager.shared
    
    public func sendFriendCode(_ code: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        let target = FriendAPI.sendFriendCode(code: code)
        return networkManager.request(
            target: target,
            type: VoidResponse.self
        )
    }
    
    public func fetchFriendList() -> AnyPublisher<BaseResponse<FriendResponse>, NetworkError> {
        let target = FriendAPI.fetchFriendList
        return networkManager.request(
            target: target,
            type: FriendResponse.self
        )
    }
    
    public func reportFriend(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        let target = FriendAPI.reportFriend(memberId: memberId)
        return networkManager.request(
            target: target,
            type: VoidResponse.self
        )
    }
    
    public func unFriend(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        let target = FriendAPI.unFriend(memberId: memberId)
        return networkManager.request(
            target: target,
            type: VoidResponse.self
        )
    }
    
    public func updateConnectionStatus() -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        let target = FriendAPI.updateConnectionStatus
        return networkManager.request(
            target: target,
            type: VoidResponse.self
        )
    }
}
