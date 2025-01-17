//
//  GameInviteResponse.swift
//  Domain
//
//  Created by ukseung.dev on 1/17/25.
//

public struct GameInviteResponse: Decodable {
    let gameInfo: GameInfo
}

public struct GameInfo: Decodable {
    let gameId: Int
    let requestMemberId: Int
    let requestNickname: String
    let receivedMemberId: Int
    let receivedNickname: String
    let distance: Double
    let timeLimit: Int
}
