//
//  LoginFeature.swift
//  Presentation
//
//  Created by inforex on 12/26/24.
//

import SwiftUI
import Foundation
import CoreLocation
import AuthenticationServices
import Combine

import Domain
import Shared

import ComposableArchitecture
import KakaoSDKUser
import KakaoSDKAuth
import Data

public enum SocialLoginType: String, Equatable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

@Reducer
public struct LoginFeature {
    
    @Dependency(\.authUseCase) var authUseCase
    private let tokenManager = TokenManager.shared
    
    public init () {}
    
    public struct State: Equatable {
        public init () {}
        
        var toast: Toast?
        
        /// 자동 로그인이 가능한지
        var isLoginRequired = false
        
        var idToken: String = ""
        var socialLoginType: SocialLoginType?
        var nickName: String?
        var profileImageUrl: String?
        
        var successLogin: Bool = false
    }
    
    public enum Action {
        case onAppear
        
        case kakaoLoginButtonTapped
        case setKakaoProfile(String, String)
        case requestLogin(String, SocialLoginType)
        
        case joinMembers(String, SocialLoginType)
        
        case setError(NetworkError)
        case showToast(String)
        case dismissToast
        
        case successGetToken(TokenResponse)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            if let refreshToken: String = UserDefaultsManager.shared.get(forKey: .refreshToken),
               let isAutoLogin: Bool = UserDefaultsManager.shared.get(forKey: .isAutoLogin),
               isAutoLogin {
                return refreshAccessToken(refreshToken: refreshToken)
            } else {
                UserDefaultsManager.shared.set(false, forKey: .isAutoLogin)
                withAnimation {
                    state.isLoginRequired = true
                }
                return .none
            }
            
        case .kakaoLoginButtonTapped:
            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡 앱으로 로그인
                return kakaoLoginWithApp()
            } else {
                // 카톡이 설치가 안 되어 있을 때
                // 카카오 계정으로 로그인
                return kakaoLoginWithAccount()
            }
        case .requestLogin(let idToken, let socialLoginType):
            state.idToken = idToken
            state.socialLoginType = socialLoginType
            return requestLogin(idToken: idToken, socialLoginType: socialLoginType)
            
        case .setKakaoProfile(let nickName, let profileImageUrl):
            state.nickName = nickName
            state.profileImageUrl = profileImageUrl
            return .none
            
        case .joinMembers(let idToken, let socialLoginType):
            
            return joinMembers(idToken: idToken,
                               socialLoginType: socialLoginType,
                               nickname: state.nickName,
                               profileImageUrl: state.profileImageUrl)
            
        case .setError(let error):
            if case .serverDefinedError(let serverError) = error {
                switch serverError {
                case .userNotRegistered:
                    
                    guard let socialLoginType = state.socialLoginType else { return .none }
                    
                    if socialLoginType == .kakao {
                        return .concatenate([
                            getKakaoProfile(),
                            .send(.joinMembers(state.idToken, socialLoginType))
                        ])
                    } else {
                        return .send(.joinMembers(state.idToken, socialLoginType))
                    }
                case .requiredLogin:
                    UserDefaultsManager.shared.set(false, forKey: .isAutoLogin)
                    withAnimation {
                        state.isLoginRequired = true
                    }
                    return .none

                default:
                    state.idToken = ""
                    state.socialLoginType = nil
                    state.nickName = nil
                    state.profileImageUrl = nil
                    return .send(.showToast("다시 시도해주세요."))
                }
            } else {
                // 토큰 재발급 불가능
                UserDefaultsManager.shared.set(false, forKey: .isAutoLogin)
                withAnimation {
                    state.isLoginRequired = true
                }
            }
            return .none
        case .showToast(let content):
            state.toast = Toast(content: content)
            return .none
            
        case .dismissToast:
            state.toast = nil
            return .none
            
        case .successGetToken(let tokenResponse):
            print("로그인 성공 accessToken ⤵️\n\(tokenResponse.accessToken)")
            print("로그인 성공 refreshToken ⤵️\n\(tokenResponse.refreshToken)")
            
            tokenManager.saveTokens(
                accessToken: tokenResponse.accessToken,
                refreshToken: tokenResponse.refreshToken
            )
            
            UserDefaultsManager.shared.set(tokenResponse.memberId, forKey: .memberId)
            UserDefaultsManager.shared.set(true, forKey: .isAutoLogin)
            state.successLogin = true
            return .none
        }
    }
}
// MARK: - KAKAO LOGIN
public extension LoginFeature {
    /// 카카오 앱으로 로그인
    private func kakaoLoginWithApp() -> Effect<Action> {
        return .run { @MainActor send in
            await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error = error {
                        send(.showToast("카카오 로그인에 실패했어요. 다시 시도해주세요."))
                        continuation.resume()
                    } else if let oauthToken = oauthToken {
                        guard let idToken = oauthToken.idToken else {
                            continuation.resume()
                            return
                        }
                        
                        send(.requestLogin(idToken, .kakao))
                        continuation.resume()
                    }
                }
            }
        }
    }
    
    /// 카카오 계정으로 로그인
    private func kakaoLoginWithAccount() -> Effect<Action> {
        return .run { @MainActor send in
            await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        send(.showToast("카카오 로그인에 실패했어요. 다시 시도해주세요."))
                        continuation.resume()
                    } else {
                        guard let idToken = oauthToken?.idToken else {
                            continuation.resume()
                            return
                        }
                        
                        send(.requestLogin(idToken, .kakao))
                        continuation.resume()
                    }
                }
            }
        }
    }
    
    /// 카카오 프로필 가져오기(닉네임, 프로필사진)
    private func getKakaoProfile() -> Effect<Action> {
        return .run { @MainActor send in
            await withCheckedContinuation { continuation in
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print("카카오톡 프로필 가져오기 실패: \(error.localizedDescription)")
                        continuation.resume()
                    } else {
                        guard let nickname = user?.kakaoAccount?.profile?.nickname,
                              let profileImageUrl = user?.kakaoAccount?.profile?.profileImageUrl else {
                            continuation.resume()
                            return
                        }
                        
                        send(.setKakaoProfile(nickname, profileImageUrl.absoluteString))
                        continuation.resume()
                    }
                }
            }
        }
    }
}

// MARK: - LOGIN API
public extension LoginFeature {
    /// accessToken 재발급
    private func refreshAccessToken(refreshToken: String) -> Effect<Action> {
        return Effect.publisher {
            authUseCase.refreshAccessToken(refreshToken: refreshToken)
                .receive(on: DispatchQueue.main)
                .map {
                    if let tokenResponse = $0.data {
                        return Action.successGetToken(tokenResponse)
                    } else {
                        return Action.setError(.unknownError)
                    }
                }
                .catch { error -> Just<Action> in
                    return Just(Action.setError(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    /// 로그인 요청
    private func requestLogin(
        idToken: String,
        socialLoginType: SocialLoginType
    ) -> Effect<Action> {
        
        return Effect.publisher {
            authUseCase.socialLogin(idToken: idToken,
                                    socialProvider: socialLoginType.rawValue)
                .receive(on: DispatchQueue.main)
                .map {
                    if let tokenResponse = $0.data {
                        return Action.successGetToken(tokenResponse)
                    } else {
                        return Action.setError(.unknownError)
                    }
                }
                .catch { error -> Just<Action> in
                    return Just(Action.setError(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    /// 회원가입 요청
    private func joinMembers(
        idToken: String,
        socialLoginType: SocialLoginType,
        nickname: String?,
        profileImageUrl: String?
    ) -> Effect<Action> {
        
        return Effect.publisher {
            authUseCase.joinMembers(idToken: idToken,
                                    socialProvider: socialLoginType.rawValue,
                                    nickname: nickname,
                                    profileImageUrl: profileImageUrl)
                .receive(on: DispatchQueue.main)
                .map {
                    if let tokenResponse = $0.data {
                        return Action.successGetToken(tokenResponse)
                    } else {
                        return Action.setError(.unknownError)
                    }
                }
                .catch { error -> Just<Action> in
                    return Just(Action.setError(error))
                }
                .eraseToAnyPublisher()
        }
    }
}
