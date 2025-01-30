//
//  GameInviteResponse.swift
//  Domain
//
//  Created by ukseung.dev on 1/17/25.
//

public struct GameInviteResponse: Decodable {
    public let gameInfo: GameInfo
}

public struct GameInfo: Decodable {
    public let gameId: Int
    public let requestMemberId: Int
    public let requestNickname: String
    public let receivedMemberId: Int
    public let receivedNickname: String
    public let distance: Double
    public let timeLimit: Int
}
