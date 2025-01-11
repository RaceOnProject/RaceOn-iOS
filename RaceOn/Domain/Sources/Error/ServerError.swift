//
//  ServerError.swift
//  Domain
//
//  Created by ukseung.dev on 1/9/25.
//

public enum ServerError: String, Error {
    // Common
    case badRequest = "COBR01"
    case invalidUrl = "COBR02"
    case requiredLogin = "COAE01"
    case invalidUserId = "COAO01"
    case unauthorized = "COAO02"
    case invalidUserToken = "COAO03"
    case internalServerError = "COIS01"
    case dataAccessException = "COES01"
    case commonUnresolvedException = "COET01"
    
    // Login
    case userNotRegistered = "AUAU01"
    
    // Friend
    case alreadyAddedFriend = "FRBR01" // 이미 친구 추가된 경우
    case invalidFriendCode = "MEBR01" // 유효하지 않은 코드

    public var message: String {
        switch self {
        // Common 오류 메시지
        case .badRequest: return "올바른 파라미터를 입력해주세요."
        case .invalidUrl: return "올바르지 않은 URL 입니다."
        case .requiredLogin: return "로그인이 필요합니다."
        case .invalidUserId: return "올바른 사용자 아이디가 아닙니다."
        case .unauthorized: return "권한이 존재하지 않습니다."
        case .invalidUserToken: return "유효하지 않는 사용자 토큰입니다."
        case .internalServerError: return "서버 내부 오류입니다."
        case .dataAccessException: return "데이터베이스와 통신하는 과정에서 오류가 발생했습니다."
        case .commonUnresolvedException: return "정의되지 않은 공통 오류입니다."
            
        // Login 오류 메시지
        case .userNotRegistered: return "회원가입이 필요합니다."
        
        // Friend 오류 메시지
        case .alreadyAddedFriend: return "이미 추가된 친구입니다."
        case .invalidFriendCode: return "유효하지 않은 코드에요."
        }
    }
}
