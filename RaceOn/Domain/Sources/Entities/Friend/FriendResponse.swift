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
    public var selected: Bool
    public let friendId: Int
    public let friendNickname: String
    public let profileImageUrl: String
    public let lastActiveAt: String
    public let playing: Bool
    
    enum CodingKeys: String, CodingKey {
        case friendId, friendNickname, profileImageUrl, lastActiveAt, playing
    }
    
    // Custom Decoding to include selected
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        friendId = try container.decode(Int.self, forKey: .friendId)
        friendNickname = try container.decode(String.self, forKey: .friendNickname)
        profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
        lastActiveAt = try container.decode(String.self, forKey: .lastActiveAt)
        playing = try container.decode(Bool.self, forKey: .playing)
        
        // selected 값을 false로 기본 설정
        selected = false
    }
}
