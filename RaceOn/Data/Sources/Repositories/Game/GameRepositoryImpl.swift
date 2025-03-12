//
//  GameRepositoryImpl.swift
//  Data
//
//  Created by ukseung.dev on 1/17/25.
//  aasds

import Foundation
import Combine

import Domain

import ComposableArchitecture
import Moya
import Alamofire

public final class GameRepositoryImpl: GameRepositoryProtocol {
    public init() {}
    
    private let networkManager: NetworkManager = NetworkManager.shared
    
    public func inviteGame(friendId: Int, distance: Double, timeLimit: Int) -> AnyPublisher<BaseResponse<GameInviteResponse>, NetworkError> {
        return networkManager.request(
            target: GameAPI.inviteGame(
                friendId: friendId,
                distance: distance,
                timeLimit: timeLimit
            ),
            type: GameInviteResponse.self
        )
    }
}
