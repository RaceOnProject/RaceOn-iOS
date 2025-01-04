//
//  FriendResponse.swift
//  Domain
//
//  Created by ukBook on 1/4/25.
//

import Foundation

// MARK: - Response 모델
public struct FriendResponse: Codable {
    public let code: String
    public let message: String
    public let data: FriendData
    public let success: Bool
}

// MARK: - Data 모델
public struct FriendData: Codable {
    public let friends: [Friend]
}

// MARK: - Friend 모델
public struct Friend: Codable, Equatable, Identifiable {
    public let id = UUID()
    public let friendId: Int
    public let friendNickname: String
    public let lastActiveAt: String
    public let playing: Bool
}

