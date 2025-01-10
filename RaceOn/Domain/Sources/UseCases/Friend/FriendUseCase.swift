//
//  FriendUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

import ComposableArchitecture
import Combine

public protocol FriendUseCaseProtocol {
    func sendFriendCode(_ code: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
    func fetchFriendList() -> AnyPublisher<BaseResponse<FriendResponse>, NetworkError>
    func reportFriend(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
    func unFriend(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
}

public final class FriendUseCase: FriendUseCaseProtocol {
    private let repository: FriendRepositoryProtocol
    
    public init(repository: FriendRepositoryProtocol) {
        self.repository = repository
    }
    
    public func sendFriendCode(_ code: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return repository.sendFriendCode(code)
    }
    
    public func fetchFriendList() -> AnyPublisher<BaseResponse<FriendResponse>, NetworkError> {
        return repository.fetchFriendList()
    }
    
    public func reportFriend(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return repository.reportFriend(memberId: memberId)
    }
    
    public func unFriend(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return repository.unFriend(memberId: memberId)
    }
}
