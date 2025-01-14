//
//  File.swift
//  Domain
//
//  Created by inforex on 1/10/25.
//

import ComposableArchitecture
import Combine

public protocol AuthUseCaseProtocol {
    func socialLogin(idToken: String, socialProvider: String) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError>
    
    func joinMembers(idToken: String,
                     socialProvider: String,
                     nickname: String?,
                     profileImageUrl: String?) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError>
}

public final class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    public func socialLogin(
        idToken: String,
        socialProvider: String
    ) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError> {
        return repository.socialLogin(idToken: idToken, socialProvider: socialProvider)
    }
    
    public func joinMembers(
        idToken: String,
        socialProvider: String,
        nickname: String?,
        profileImageUrl: String?
    ) -> AnyPublisher<BaseResponse<TokenResponse>, NetworkError> {
        return repository.joinMembers(idToken: idToken, socialProvider: socialProvider, nickname: nickname, profileImageUrl: profileImageUrl)
    }
}
