//
//  GameAPI.swift
//  Data
//
//  Created by ukseung.dev on 1/17/25.
//

import Moya
import Foundation

public enum GameAPI {
    case inviteGame(friendId: Int, distance: Double, timeLimit: Int)
}

extension GameAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.runner-dev.shop")!
    }
    
    public var path: String {
        switch self {
        case .inviteGame: return "/games"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case .inviteGame(let friendId, let distance, let timeLimit):
            return .requestParameters(
                parameters: [
                    "friendId": friendId,
                    "distance": distance,
                    "timeLimit": timeLimit
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var headers: [String: String]? {
        switch self {
        case .inviteGame:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}

