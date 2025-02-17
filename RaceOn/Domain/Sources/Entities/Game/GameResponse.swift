//
//  GameResponse.swift
//  Domain
//
//  Created by ukseung.dev on 2/17/25.
//

import Foundation

public struct ResponseData: Decodable {
    public let command: String
    public let statusCode: Int
    public let code: String
    public let message: String
    public let data: GameResponse
    public let success: Bool
}

public struct GameResponse: Decodable {
    public let gameId: Int
    public let memberId: Int
    public let time: String
    public let latitude: Double
    public let longitude: Double
    public let distance: Double
    public let winMemberId: Int?
    public let finished: Bool
}
