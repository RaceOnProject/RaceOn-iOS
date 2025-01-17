//
//  GameRepositoryProtocol.swift
//  Domain
//
//  Created by ukseung.dev on 1/17/25.
//

import Combine

public protocol GameRepositoryProtocol {
    func inviteGame(friendId: Int, distance: Double, timeLimit: Int) -> AnyPublisher<BaseResponse<GameInviteResponse>, NetworkError>
}
