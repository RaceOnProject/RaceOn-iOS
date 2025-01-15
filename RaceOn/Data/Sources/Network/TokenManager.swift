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

class TokenManager {
    static let shared = TokenManager()
    private init() {
        // TODO: refresh Token 하드코딩 (배포시 삭제)
        if let refreshToken: String = UserDefaultsManager.shared.get(forKey: .refreshToken) {
            self.refreshToken = refreshToken
        } else {
            self.refreshToken = "eyJhbGciOiJIUzUxMiJ9.eyJhdXRob3JpdHkiOiJOT1JNQUxfVVNFUiIsInRva2VuVHlwZSI6IlJFRlJFU0hfVE9LRU4iLCJzdWIiOiIxIiwiZXhwIjoxNzM3ODU5ODEwfQ.o1sDRZaWyQotQuhpIIMe95BGvIBgkVfanX0EI0tdwCXF1I72LQdO_0jg1c8BXSRKOdDCr9IIeaiUAOYTxL_enA"
        }
        
        // 앱 실행 시 저장된 토큰을 불러옴
        accessToken = UserDefaultsManager.shared.get(forKey: .accessToken)
    }
    
    var accessToken: String?
    var refreshToken: String?
    
    func saveTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        UserDefaultsManager.shared.set(accessToken, forKey: .accessToken)
        UserDefaultsManager.shared.set(refreshToken, forKey: .refreshToken)
    }
    
    /// 로그인 화면으로 이동
    func logout() {
        // 토큰 초기화 및 로그아웃 처리
        accessToken = nil
        refreshToken = nil
//        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
}
