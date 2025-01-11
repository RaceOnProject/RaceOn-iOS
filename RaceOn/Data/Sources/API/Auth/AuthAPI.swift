//
//  AuthAPI.swift
//  Data
//
//  Created by ukseung.dev on 1/2/25.
//

//
//  AuthAPI.swift
//  Data
//
//  Created by ukseung.dev on 1/2/25.
//

import Moya
import Foundation

public enum AuthAPI {
    case guestLogin(memberId: String)
    case refreshAccessToken(refreshToken: String)
    case socialLogin(idToken: String, socialProvider: String)
    case joinMembers(idToken: String, socialProvider: String, profileImageUrl: String?)
}

extension AuthAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.runner-dev.shop")!
    }
    
    public var path: String {
        switch self {
        case .guestLogin: return "/auth/login"
        case .refreshAccessToken: return "/auth/reissue"
        case .socialLogin: return "/auth/login"
        case .joinMembers: return "/members"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case .guestLogin(let memberId):
            return .requestParameters(
                parameters: [
                    "memberID": memberId
                ],
                encoding: URLEncoding.queryString
            )
        case .socialLogin(let idToken, let socialProvider):
            return .requestParameters(
                parameters: [
                    "idToken": idToken,
                    "socialProvider": socialProvider
                ],
                encoding: JSONEncoding.default
            )
        case .joinMembers(let idToken, let socialProvider, let profileImageUrl):
            return .requestParameters(
                parameters: [
                    "idToken": idToken,
                    "socialProvider": socialProvider,
                    "profileImageUrl": profileImageUrl
                ],
                encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .guestLogin, .socialLogin, .joinMembers:
            return [
                "Content-Type": "application/json"
            ]
        case .refreshAccessToken(let refreshToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(refreshToken)"
            ]
        }
    }
}
