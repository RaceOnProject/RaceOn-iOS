//
//  FriendAPI.swift
//  Data
//
//  Created by ukseung.dev on 1/2/25.
//

import Moya
import Foundation
import Shared

public enum FriendAPI {
    case sendFriendCode(code: String)
    case fetchFriendList
}

extension FriendAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.runner-dev.shop")!
    }
    
    public var path: String {
        switch self {
        case .sendFriendCode, .fetchFriendList: return "/friends"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sendFriendCode: return .post
        case .fetchFriendList: return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .sendFriendCode(let code):
            return .requestParameters(
                parameters: [
                    "friendCode": code
                ],
                encoding: JSONEncoding.default
            )
        case .fetchFriendList:
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
