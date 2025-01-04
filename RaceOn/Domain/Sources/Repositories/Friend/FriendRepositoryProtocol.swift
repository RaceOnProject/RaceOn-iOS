//
//  FriendRepositoryProtocol.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

import Combine

public protocol FriendRepositoryProtocol {
    func sendFriendCode(_ code: String) -> AnyPublisher<AddFriendResponse, Error>
    func fetchFriendList() -> AnyPublisher<FriendResponse, Error>
}
