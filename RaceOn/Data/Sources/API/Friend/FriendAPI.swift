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
    case reportFriend(memberId: Int)
    case unFriend(memberId: Int)
    case updateConnectionStatus
}

extension FriendAPI: TargetType {
    public var baseURL: URL {
#if DEBUG
    return URL(string: "https://api.runner-dev.shop")!
#else
    return URL(string: "https://api.runner-prod.shop")!
#endif
}
    
    public var path: String {
        switch self {
        case .sendFriendCode, .fetchFriendList, .unFriend: return "/friends"
        case .reportFriend: return "/report/members"
        case .updateConnectionStatus: return "/connection-status"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sendFriendCode: return .post
        case .fetchFriendList: return .get
        case .reportFriend: return .post
        case .unFriend: return .delete
        case .updateConnectionStatus: return .put
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
        case .reportFriend(let memberId):
            return .requestParameters(
                parameters: [
                    "reportedMemberId": memberId
                ],
                encoding: JSONEncoding.default
            )
        case .unFriend(let memberId):
            return .requestParameters(
                parameters: [
                    "friendId": memberId
                ],
                encoding: JSONEncoding.default
            )
        case .updateConnectionStatus:
            return .requestPlain
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
