//
//  MemberInfo.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

public struct MemberInfo: Decodable, Equatable {
    public let memberId: Int
    public let nickname: String
    public let profileImageUrl: String
    public let memberCode: String
}
