//
//  AuthRepositoryProtocol.swift
//  Domain
//
//  Created by inforex on 1/10/25.
//

import Combine

public protocol AuthRepositoryProtocol {
    func refreshAccessToken(refreshToken: String) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError>
    
    func socialLogin(idToken: String, socialProvider: String) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError>
    func logout(accessToken: String, refreshToken: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
    
    func joinMembers(idToken: String, socialProvider: String, nickname: String?, profileImageUrl: String?)
    -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError>
    func registerFCMToken(memberId: Int, fcmToken: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
}
