//
//  TokenResponse.swift
//  Domain
//
//  Created by ukBook on 1/4/25.
//

public struct TokenResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String
}
