//
//  FriendResponse.swift
//  Domain
//
//  Created by ukBook on 1/4/25.
//

import Foundation

// MARK: - Data 모델
public struct FriendResponse: Decodable {
    public let friends: [Friend]
}

// MARK: - Friend 모델
public struct Friend: Decodable, Equatable, Identifiable {
    public let id = UUID()
    public let friendId: Int
    public let friendNickname: String
    public let profileImageUrl: String
    public let lastActiveAt: String
    public let playing: Bool
}
