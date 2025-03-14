//
//  GameResponse.swift
//  Domain
//
//  Created by ukseung.dev on 2/17/25.
//

import Foundation

public struct ProcessData: Decodable {
    public let command: String
    public let statusCode: Int
    public let code: String
    public let message: String
    public let data: ProcessResponse
    public let success: Bool
}

public struct ProcessResponse: Decodable {
    public let gameId: Int
    public let memberId: Int
    public let time: String
    public let latitude: Double
    public let longitude: Double
    public let distance: Double
    public let winMemberId: Int?
    public let isFinished: Bool
}
