//
//  ProfileAPI.swift
//  Data
//
//  Created by ukseung.dev on 12/27/24.
//

import Moya
import Foundation

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
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJhdXRob3JpdHkiOiJOT1JNQUxfVVNFUiIsInRva2VuVHlwZSI6IkFDQ0VTU19UT0tFTiIsInN1YiI6IjEiLCJleHAiOjE3MzU3OTU2MDh9.cK7E5nNekusGWAFPkpg_XCWhHzMY_NzAN2DL_zujHQrh8K_L_Cq6vslTL-S1ulANx6u4bpJtFlDRb5ukVtyQbA"
        ]
    }
}
