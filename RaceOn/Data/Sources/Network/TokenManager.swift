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
        UserDefaultsManager.shared.set("eyJhbGciOiJIUzUxMiJ9.eyJhdXRob3JpdHkiOiJOT1JNQUxfVVNFUiIsInRva2VuVHlwZSI6IlJFRlJFU0hfVE9LRU4iLCJzdWIiOiIxIiwiZXhwIjoxNzM3NDIyNDcwfQ.g35HtCLEXB8sYvdrwQoKt2b5-lFsRt6Hh60J8WGWgUffSIdab_3DGX35tcKsvS5F_l4PgML_uakPH5oqLd3xGA", forKey: .refreshToken)
        
        // 앱 실행 시 저장된 토큰을 불러옴
        accessToken = UserDefaultsManager.shared.get(forKey: .accessToken)
        refreshToken = UserDefaultsManager.shared.get(forKey: .refreshToken)
    }
    
    var accessToken: String?
    var refreshToken: String?
    
    func saveTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        UserDefaultsManager.shared.set(accessToken, forKey: .accessToken)
        UserDefaultsManager.shared.set(refreshToken, forKey: .refreshToken)
    }
    
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = refreshToken else {
            // TODO: Refresh Token이 없을 경우, 로그아웃 처리
            self.logout()
            completion(false)
            return
        }
        
        // Moya를 사용하여 Refresh Token 요청
        let provider = MoyaProvider<AuthAPI>()
        provider.request(.refreshAccessToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                    self.saveTokens(accessToken: tokenResponse.data.accessToken, refreshToken: tokenResponse.data.refreshToken)
                    completion(true)
                } catch {
                    // TODO: 에러 처리
                    completion(false)
                }
            case .failure:
                self.logout()
                // TODO: 에러 처리
                completion(false)
            }
        }
    }
    
    /// 로그인 화면으로 이동
    func logout() {
        // 토큰 초기화 및 로그아웃 처리
        accessToken = nil
        refreshToken = nil
//        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
}
