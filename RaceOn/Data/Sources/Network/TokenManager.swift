//
//  TokenManager.swift
//  Data
//
//  Created by ukseung.dev on 1/2/25.
//

import Moya
import Shared
import Foundation
import Domain
import Dependencies

public final class TokenManager {
    public static let shared = TokenManager()
    
    public init() {
        // TODO: access Token, refresh Token이 없으면 로그아웃
        refreshToken = UserDefaultsManager.shared.get(forKey: .refreshToken)
        accessToken = UserDefaultsManager.shared.get(forKey: .accessToken)
    }
    
    public var accessToken: String?
    public var refreshToken: String?
    
    public func saveTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        UserDefaultsManager.shared.set(accessToken, forKey: .accessToken)
        UserDefaultsManager.shared.set(refreshToken, forKey: .refreshToken)
    }
    
    /// 로그인 화면으로 이동
    public func logout() {
        // 토큰 초기화 및 로그아웃 처리
        accessToken = nil
        refreshToken = nil
//        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
}
