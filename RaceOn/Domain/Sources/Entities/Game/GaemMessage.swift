//
//  GaemMessage.swift
//  Domain
//
//  Created by ukBook on 1/30/25.
//

// JSON 디코딩할 모델
public struct GameMessage: Decodable {
    public let command: String
    public let statusCode: Int
    public let code: String
    public let message: String
    public let data: GameData?
    public let success: Bool
}

public struct GameData: Decodable {
    public let gameId: Int
    public let startTime: String?
    public let matched: Bool
}

public struct RejectMessage: Decodable {
    public let command: String
    public let statusCode: Int
    public let code: String
    public let message: String
    public let data: RejectData?
    public let success: Bool
}

public struct RejectData: Decodable {
    public let gameId: Int
    public let failMatching: Bool
}
