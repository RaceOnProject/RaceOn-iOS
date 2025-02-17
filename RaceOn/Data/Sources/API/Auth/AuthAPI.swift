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
    case logout(accessToken: String, refreshToken: String)
    case joinMembers(idToken: String, socialProvider: String, nickname: String?, profileImageUrl: String?)
    case registerFCMToken(memberId: Int, fcmToken: String)
}

extension AuthAPI: TargetType {
    public var baseURL: URL {
    #if DEBUG
        return URL(string: "https://api.runner-dev.shop")!
    #else
        return URL(string: "https://api.runner-prod.shop")!
    #endif
    }
    
    public var path: String {
        switch self {
        case .guestLogin: return "/auth/login"
        case .refreshAccessToken: return "/auth/reissue"
        case .socialLogin: return "/auth/login"
        case .logout: return "auth/logout"
        case .joinMembers: return "/members"
        case .registerFCMToken(let memberId, _): return "/tokens/\(memberId)"
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
            
        case .refreshAccessToken:
            return .requestPlain
            
        case .socialLogin(let idToken, let socialProvider):
            return .requestParameters(
                parameters: [
                    "idToken": idToken,
                    "socialProvider": socialProvider
                ],
                encoding: JSONEncoding.default
            )
        case .logout(let accessToken, let refreshToken):
            return .requestParameters(
                parameters: [
                    "accessToken" : accessToken,
                    "refreshToken" : refreshToken
                ],
                encoding: JSONEncoding.default
            )
        
        case .joinMembers(let idToken, let socialProvider, let nickname, let profileImageUrl):
            return .requestParameters(
                parameters: [
                    "idToken": idToken,
                    "socialProvider": socialProvider,
                    "nickname": nickname,
                    "profileImageUrl": profileImageUrl
                ],
                encoding: JSONEncoding.default)
        case .registerFCMToken(_, let fcmToken):
            return .requestParameters(
                parameters: [
                    "token": fcmToken
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .guestLogin, .socialLogin, .joinMembers, .registerFCMToken, .logout:
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
