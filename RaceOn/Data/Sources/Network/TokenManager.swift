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
        // 앱 실행 시 저장된 토큰을 불러옴
//        accessToken = UserDefaultsManager.shared.get(forKey: .accessToken)
//        refreshToken = UserDefaultsManager.shared.get(forKey: .refreshToken)
        
        // TEST
        // TODO: 로그인 작업이 완료되면 해당 코드 삭제 할 것
        accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJhdXRob3JpdHkiOiJOT1JNQUxfVVNFUiIsInRva2VuVHlwZSI6IkFDQ0VTU19UT0tFTiIsInN1YiI6IjEiLCJleHAiOjE3MzU5ODQyNTB9.7CnSymnm7C-kJ_v92lFDfAGDhbSJZCV_1EfRjCWbKDl61pxa3VGfXSdtOUX3TYxYX8q-SgS9oMb0JFCYgtb37Hg"
        refreshToken = "eyJhbGciOiJIUzUxMiJ9.eyJhdXRob3JpdHkiOiJOT1JNQUxfVVNFUiIsInRva2VuVHlwZSI6IlJFRlJFU0hfVE9LRU4iLCJzdWIiOiIxIiwiZXhwIjoxNzM3MTc3NTI4fQ.cMhkmZBJBnmf051iidvnjqwRANG73GvqJFHVCTogr0q8g9kxcUGhX8a2CqTOUxhLr6F2YL8eGOAREzt1KdNYlA"
    }
    
    var accessToken: String?
    var refreshToken: String?
    
    func saveTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        UserDefaultsManager.shared.set(accessToken, forKey: .accessToken)
        UserDefaultsManager.shared.set(refreshToken, forKey: .refreshToken)
    }
    
    // TODO: 로그인 하드코딩(배포 시 삭제 예정)
    func requestAccessToken(completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<AuthAPI>()
        provider.request(.guestLogin(memberId: "1")) { result in
            switch result {
            case .success(let response):
                print(response)
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                    self.saveTokens(accessToken: tokenResponse.data.accessToken, refreshToken: tokenResponse.data.refreshToken)
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
            }
        }
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
                    completion(false)
                }
            case .failure:
                self.logout()
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
