//
//  TokenResponse.swift
//  Domain
//
//  Created by ukBook on 1/4/25.
//

public struct TokenResponse: Decodable, Equatable {
    public let accessToken: String
    public let refreshToken: String
    public let memberId: Int
}
