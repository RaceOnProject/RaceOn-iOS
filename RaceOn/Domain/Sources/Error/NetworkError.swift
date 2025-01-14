//
//  NetworkError.swift
//  Data
//
//  Created by ukseung.dev on 1/8/25.
//

// 네트워크 관련 오류 정의
public enum NetworkError: Error {
    case networkFailure(Error)         // 네트워크 연결 오류
    case serverDefinedError(ServerError)    // 서버에서 정의된 에러 메시지
    case serverError(Int)              // 서버 오류 (HTTP 상태 코드)
    case decodingError(Error)          // 디코딩 오류
    case unknownError                  // 알 수 없는 오류
    
    // 오류 메시지를 출력할 수 있도록 설명 추가
    public var message: String {
        switch self {
        case .networkFailure(let error):
            return "Network failure: \(error.localizedDescription)"
        case .serverDefinedError(let serverError):
            return serverError.message
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unknownError:
            return "Unknown error occurred"
        }
    }
}

