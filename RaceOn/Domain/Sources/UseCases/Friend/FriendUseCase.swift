//
//  FriendUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

import ComposableArchitecture
import Combine

public protocol FriendUseCaseProtocol {
    func sendFriendCode(_ code: String) -> AnyPublisher<AddFriendResponse, Error>
    func fetchFriendList() -> AnyPublisher<FriendResponse, Error>
}

public final class FriendUseCase: FriendUseCaseProtocol {
    private let repository: FriendRepositoryProtocol
    
    public init(repository: FriendRepositoryProtocol) {
        self.repository = repository
    }
    
    public func sendFriendCode(_ code: String) -> AnyPublisher<AddFriendResponse, Error> {
        repository.sendFriendCode(code)
    }
    
    public func fetchFriendList() -> AnyPublisher<FriendResponse, any Error> {
        repository.fetchFriendList()
    }
}
