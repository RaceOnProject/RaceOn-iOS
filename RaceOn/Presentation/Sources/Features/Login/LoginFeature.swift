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

import ComposableArchitecture
import KakaoSDKUser
import KakaoSDKAuth

public enum SocialLoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

@Reducer
public struct LoginFeature {
    
    @Dependency(\.authUseCase) var authUseCase
    
    public init () {}
    
    public struct State: Equatable {
        public init () {}
    }
    
    public enum Action: Equatable {
        case kakaoLoginButtonTapped
        case requestLogin(String, SocialLoginType)
        case responseLogin(TokenResponse)
        
        case joinMembers(String, SocialLoginType, String)
        case responseJoinMembers
        
        case setErrorMessage(String)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
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
            return requestLogin(idToken: idToken, socialLoginType: socialLoginType)
            
        case .responseLogin(let tokenResponse):
            print("accessToken >> \(tokenResponse.accessToken)")
            print("refreshToken >> \(tokenResponse.refreshToken)")
            return .none
            
        case .joinMembers(let idToken, let socialLoginType, let profileImageUrl):
            return joinMembers(idToken: idToken, socialLoginType: socialLoginType, profileImageUrl: profileImageUrl)
            
        case .responseJoinMembers:
            return .none
            
        case .setErrorMessage(let message):
            print("error >> \(message)")
            return .none
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
                        
//                        getKakaoProfileImage()
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
                        
//                        getKakaoProfileImage()
                        send(.requestLogin(idToken, .kakao))
                        continuation.resume()
                    }
                }
            }
        }
    }
    
//    private func getKakaoProfileImage() {
//        UserApi.shared.me() {(user, error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("me() success.")
//                print("카캌오 프로필 \(user?.kakaoAccount?.profile?.profileImageUrl)")
//                user?.kakaoAccount?.profile?.profileImageUrl
//                // 성공 시 동작 구현
//                _ = user
//            }
//        }
//    }
}

// MARK: - LOGIN API
public extension LoginFeature {
    private func requestLogin(idToken: String, socialLoginType: SocialLoginType) -> Effect<Action> {
        print("idTokens: \(idToken), socialType: \(socialLoginType)")
        
        return Effect.publisher {
            authUseCase.socialLogin(idToken: idToken, socialProvider: socialLoginType.rawValue)
                .receive(on: DispatchQueue.main)
                .map {
                    if let tokenResponse = $0.data {
                        return Action.responseLogin(tokenResponse)
                    } else {
                        return Action.setErrorMessage("로그인에 실패했습니다.")
                    }
                }
                .catch { error -> Just<Action> in
                    let errorMessage = error.message
                    return Just(Action.setErrorMessage(errorMessage))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func joinMembers(
        idToken: String,
        socialLoginType: SocialLoginType,
        profileImageUrl: String?
    ) -> Effect<Action> {
        print("idTokens: \(idToken), socialType: \(socialLoginType), profileImageUrl: \(String(describing: profileImageUrl))")
        
        return Effect.publisher {
            authUseCase.joinMembers(idToken: idToken, socialProvider: socialLoginType.rawValue, profileImageUrl: profileImageUrl)
                .receive(on: DispatchQueue.main)
                .map {
                    if let tokenResponse = $0.data {
                        return Action.responseJoinMembers
                        // 회원가입 성공
                    } else {
                        return Action.setErrorMessage("회원가입에 실패했습니다.")
                    }
                }
                .catch { error -> Just<Action> in
                    let errorMessage = error.message
                    return Just(Action.setErrorMessage(errorMessage))
                }
                .eraseToAnyPublisher()
        }
    }
}
