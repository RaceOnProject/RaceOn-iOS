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
    case fetchMemberInfo(memberId: Int)
    case deleteAccount(memberId: Int)
}

extension MemberAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.runner-dev.shop")!
    }
    
    public var path: String {
        switch self {
        case .fetchMemberInfo(let memberId), .deleteAccount(let memberId): 
            return "/members/\(memberId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchMemberInfo: return .get
        case .deleteAccount: return .delete
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchMemberInfo, .deleteAccount:
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
