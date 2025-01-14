//
//  AuthRepositoryProtocol.swift
//  Domain
//
//  Created by inforex on 1/10/25.
//

import Combine

public protocol AuthRepositoryProtocol {
    func socialLogin(idToken: String, socialProvider: String) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError>
    
    func joinMembers(idToken: String, socialProvider: String, nickname: String?, profileImageUrl: String?)
    -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError>
}
