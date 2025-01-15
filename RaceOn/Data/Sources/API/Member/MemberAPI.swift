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
    case requestImageEditPermission(memberId: Int)
    case uploadImageS3(url: String, pngData: Data)
    case updateProfile(memberId: Int, contentUrl: String, nickname: String)
}

extension MemberAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .fetchMemberInfo, .deleteAccount, .requestImageEditPermission, .updateProfile:
            return URL(string: "https://api.runner-dev.shop")!
        case .uploadImageS3(let url, _):
            return URL(string: url)!
        }
    }
    
    public var path: String {
        switch self {
        case .fetchMemberInfo(let memberId), .deleteAccount(let memberId), .updateProfile(let memberId, _, _):
            return "/members/\(memberId)"
        case .requestImageEditPermission(let memberId):
            return "/members/\(memberId)/profile-image"
        case .uploadImageS3:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchMemberInfo: return .get
        case .deleteAccount: return .delete
        case .requestImageEditPermission, .updateProfile: return .patch
        case .uploadImageS3: return .put
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchMemberInfo, .deleteAccount, .requestImageEditPermission:
            return .requestPlain
        case .uploadImageS3(_, let pngData):
            return .requestData(pngData)
        case .updateProfile(_, let contentUrl, let nickname):
            return .requestParameters(
                parameters: [
                    "newProfileUrl": contentUrl,
                    "username": nickname
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
        case .fetchMemberInfo, .deleteAccount, .requestImageEditPermission, .updateProfile:
            return ["Content-Type": "application/json"]
        case .uploadImageS3:
            return ["Content-Type": "image/png"]
        }
    }
}
