//
//  StopResponse.swift
//  Domain
//
//  Created by ukseung.dev on 2/19/25.
//

import Foundation

public struct StopData: Decodable {
    public let command: String
    public let statusCode: Int
    public let code: String
    public let message: String
    public let data: StopResponse
    public let success: Bool
}

public struct StopResponse: Decodable {
    public let gameId: Int
    public let requestMemberId: Int
    public let curMemberId: Int
    public let inProgress: Bool
    public let isAgree: Bool
}
