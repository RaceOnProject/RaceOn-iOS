//
//  BaseResponse.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

// 빈 응답 모델
public struct VoidResponse: Decodable {}

// 공통 응답 구조체
public struct BaseResponse<T: Decodable>: Decodable {
    public let code: String
    public let message: String
    public let data: T?
    public let success: Bool
    
    public init(code: String, message: String, data: T? = nil, success: Bool) {
        self.code = code
        self.message = message
        self.data = data
        self.success = success
    }
    
    public func toError() -> ServerError? {
        return ServerError(rawValue: code)
    }
}
