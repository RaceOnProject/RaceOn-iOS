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
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJhdXRob3JpdHkiOiJOT1JNQUxfVVNFUiIsInRva2VuVHlwZSI6IkFDQ0VTU19UT0tFTiIsInN1YiI6IjEiLCJleHAiOjE3MzYwMDc4MzB9.1Tx4QlCMti7cNosFDS6x5ehjiYQ3_e_1Xvp2Jk72-CxSgGsVBPFbDCA6odIspDBnEMWp3ey-M_uTlcAaFqU8vQ"
        ]
    }
}
