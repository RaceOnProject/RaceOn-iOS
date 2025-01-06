//
//  FriendUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

import ComposableArchitecture
import Combine

public protocol FriendUseCaseProtocol {
    func sendFriendCode(_ code: String) -> AnyPublisher<CommonResponse, Error>
    func fetchFriendList() -> AnyPublisher<FriendResponse, Error>
    func reportFriend(memberId: Int) -> AnyPublisher<CommonResponse, Error>
    func unFriend(memberId: Int) -> AnyPublisher<CommonResponse, Error>
}

public final class FriendUseCase: FriendUseCaseProtocol {
    private let repository: FriendRepositoryProtocol
    
    public init(repository: FriendRepositoryProtocol) {
        self.repository = repository
    }
    
    public func sendFriendCode(_ code: String) -> AnyPublisher<CommonResponse, Error> {
        repository.sendFriendCode(code)
    }
    
    public func fetchFriendList() -> AnyPublisher<FriendResponse, any Error> {
        repository.fetchFriendList()
    }
    
    public func reportFriend(memberId: Int) -> AnyPublisher<CommonResponse, Error> {
        repository.reportFriend(memberId: memberId)
    }
    
    public func unFriend(memberId: Int) -> AnyPublisher<CommonResponse, any Error> {
        repository.unFriend(memberId: memberId)
    }
}
