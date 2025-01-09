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

import ComposableArchitecture
import KakaoSDKUser
import KakaoSDKAuth

public enum SocialLoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

@Reducer
public struct LoginFeature {
    
    public init () {}
    
    public struct State: Equatable {
        public init () {}
    }
    
    public enum Action: Equatable {
        case kakaoLoginButtonTapped
        case requestLogin(String, SocialLoginType)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .kakaoLoginButtonTapped:
            if !UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡 앱으로 로그인
                return kakaoLoginWithApp()
            } else {
                // 카톡이 설치가 안 되어 있을 때
                // 카카오 계정으로 로그인
                return kakaoLoginWithAccount()
            }
        case .requestLogin(let idToken, let socialLoginType):
            return requestLogin(idToken: idToken, socialLoginType: socialLoginType)
        }
    }
}
// MARK: - KAKAO LOGIN
public extension LoginFeature {
    
    private func kakaoLoginWithApp() -> Effect<Action> {
        return .run { @MainActor send in
            await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error = error {
                        print("카카오톡 앱 로그인 실패: \(error.localizedDescription)")
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
    
    private func kakaoLoginWithAccount() -> Effect<Action> {
        return .run { @MainActor send in
            await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print("카카오톡 계정 로그인 실패: \(error.localizedDescription)")
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
}

// MARK: - LOGIN API
public extension LoginFeature {
    private func requestLogin(idToken: String, socialLoginType: SocialLoginType) -> Effect<Action> {
        print("idTokens: \(idToken), socialType: \(socialLoginType)")
        return .none
    }
}
