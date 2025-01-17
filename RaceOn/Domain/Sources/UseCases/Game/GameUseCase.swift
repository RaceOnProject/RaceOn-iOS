//
//  GameUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 1/17/25.
//

import Combine

public protocol GameUseCaseProtocol {
    func inviteGame(friendId: Int, distance: Double, timeLimit: Int) -> AnyPublisher<BaseResponse<GameInviteResponse>, NetworkError>
}

public final class GameUseCase: GameUseCaseProtocol {
    private let repository: GameRepositoryProtocol
    
    public init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func inviteGame(friendId: Int, distance: Double, timeLimit: Int) -> AnyPublisher<BaseResponse<GameInviteResponse>, NetworkError> {
        return repository.inviteGame(
            friendId: friendId,
            distance: distance,
            timeLimit: timeLimit
        )
    }
}
