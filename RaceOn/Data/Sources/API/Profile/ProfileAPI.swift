//
//  ProfileAPI.swift
//  Data
//
//  Created by ukseung.dev on 12/27/24.
//

import Moya
import Foundation
import Shared

public enum ProfileAPI {
    case fetchMemberCode
}

extension ProfileAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.runner-dev.shop")!
    }
    
    public var path: String {
        switch self {
        case .fetchMemberCode: return "/members/1/member-code"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchMemberCode: return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchMemberCode: return .requestPlain
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
