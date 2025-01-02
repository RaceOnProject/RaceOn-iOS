//
//  FriendUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

import ComposableArchitecture
import Combine

public protocol FriendUseCaseProtocol {
    func excute(_ code: String) -> AnyPublisher<AddFriendResponse, Error>
}

public final class FriendUseCase: FriendUseCaseProtocol {
    private let repository: FriendRepositoryProtocol
    
    public init(repository: FriendRepositoryProtocol) {
        self.repository = repository
    }
    
    public func excute(_ code: String) -> AnyPublisher<AddFriendResponse, Error> {
        repository.sendFriendCode(code)
    }
}
