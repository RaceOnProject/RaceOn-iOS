//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by inforex on 1/10/25.
//

import Foundation
import Combine

import Domain

import ComposableArchitecture
import Moya
import Alamofire

public final class AuthRepositoryImpl: AuthRepositoryProtocol {
    
    public init() {}
    
    let networkManager: NetworkManager = NetworkManager.shared
    
    public func refreshAccessToken(
        refreshToken: String
    ) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError> {
        return networkManager.request(
            target: AuthAPI.refreshAccessToken(refreshToken: refreshToken),
            type: TokenResponse.self)
    }
    
    public func socialLogin(
        idToken: String,
        socialProvider: String
    ) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError> {
        return networkManager.request(
            target: AuthAPI.socialLogin(idToken: idToken,
                                        socialProvider: socialProvider),
            type: TokenResponse.self
        )
    }
    
    public func logout(accessToken: String, refreshToken: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return networkManager.request(
            target: AuthAPI.logout(
                accessToken: accessToken,
                refreshToken: refreshToken
            ),
            type: VoidResponse.self
        )
    }
    
    public func joinMembers(
        idToken: String,
        socialProvider: String,
        nickname: String?,
        profileImageUrl: String?
    ) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError> {
        return networkManager.request(
            target: AuthAPI.joinMembers(idToken: idToken,
                                        socialProvider: socialProvider,
                                        nickname: nickname,
                                        profileImageUrl: profileImageUrl),
            type: TokenResponse.self
        )
    }
    
    public func registerFCMToken(memberId: Int, fcmToken: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return networkManager.request(
            target: AuthAPI.registerFCMToken(
                memberId: memberId,
                fcmToken: fcmToken
            ),
            type: VoidResponse.self
        )
    }
}
