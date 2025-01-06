//
//  LoginFeature.swift
//  Presentation
//
//  Created by inforex on 12/26/24.
//

import SwiftUI
import Foundation
import CoreLocation

import ComposableArchitecture
import KakaoSDKUser
import KakaoSDKAuth

@Reducer
public struct LoginFeature {
    public init () {}
    
    public struct State: Equatable {
        public init () {}
    }
    
    public enum Action: Equatable {
        case kakaoLoginButtonTapped
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .kakaoLoginButtonTapped:
            
            return .none
        }
    }
}
// MARK: - KAKAO LOGIN
public extension LoginFeature {
    private func kakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 앱으로 로그인 인증
            kakaoLonginWithApp()
        } else { // 카톡이 설치가 안 되어 있을 때
            // 카카오 계정으로 로그인
            kakaoLoginWithAccount()
        }
    }
    
    func kakaoLonginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                
                // TODO: API 호출
                _ = oauthToken
            }
        }
    }
    
    
    private func kakaoLoginWithAccount() {
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                // TODO: API 호출
                _ = oauthToken
            }
        }
    }
}
