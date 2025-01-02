//
//  FriendAPI.swift
//  Data
//
//  Created by ukseung.dev on 1/2/25.
//

import Moya
import Foundation

public enum FriendAPI {
    case sendFriendCode(code: String)
}

extension FriendAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.runner-dev.shop")!
    }
    
    public var path: String {
        switch self {
        case .sendFriendCode: return "/friends"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sendFriendCode: return .post
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
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJhdXRob3JpdHkiOiJOT1JNQUxfVVNFUiIsInRva2VuVHlwZSI6IkFDQ0VTU19UT0tFTiIsInN1YiI6IjIiLCJleHAiOjE3MzU4MDM2Mzh9.JTqmd6Z3mZH859tUpLttQm88fJQmCSMd43pZeB2jFAeQqVCB5Jw7YosHvr8WNlG_m3qZOfrUOA1a9_yc2oAknQ"
        ]
    }
}
