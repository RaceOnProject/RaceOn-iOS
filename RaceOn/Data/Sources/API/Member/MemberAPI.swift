//
//  MemberAPI.swift
//  Data
//
//  Created by ukseung.dev on 12/27/24.
//

import Moya
import Foundation
import Shared

public enum MemberAPI {
    case fetchMemberCode(memberId: Int)
    case deleteAccount(memberId: Int)
}

extension MemberAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.runner-dev.shop")!
    }
    
    public var path: String {
        switch self {
        case .fetchMemberCode(let memberId): return "/members/\(memberId)/member-code"
        case .deleteAccount(let memberId): return "/members/\(memberId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchMemberCode: return .get
        case .deleteAccount: return .delete
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchMemberCode:
            return .requestPlain
        case .deleteAccount(let memberId):
            return .requestPlain
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultsManager.shared.get(forKey: .accessToken) ?? "")"
        ]
    }
}
