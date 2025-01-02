//
//  MemberCode.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

public struct MemberCode: Codable {
    public let code: String
    public let message: String
    public let data: MemberData
    public let success: Bool
}

public struct MemberData: Codable {
    public let memberCode: String
}
