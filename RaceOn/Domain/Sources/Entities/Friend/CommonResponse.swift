//
//  AddFriendResponse.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

public struct CommonResponse: Codable, Equatable {
    public let code: String
    public let message: String
    public let success: Bool
}
