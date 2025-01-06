//
//  MemberInfo.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

public struct MemberInfo: Codable, Equatable {
    public let code: String
    public let message: String
    public let data: MemberData
    public let success: Bool
}

public struct MemberData: Codable, Equatable {
    public let memberId: Int
    public let nickname: String
    public let profileImageUrl: String
    public let memberCode: String
}
