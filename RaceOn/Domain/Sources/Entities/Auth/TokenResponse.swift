//
//  TokenResponse.swift
//  Domain
//
//  Created by ukBook on 1/4/25.
//

public struct TokenResponse: Codable {
    public let code: String
    public let message: String
    public let data: TokenData
    public let success: Bool
}

public struct TokenData: Codable {
    public let accessToken: String
    public let refreshToken: String
}

