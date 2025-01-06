//
//  APIRequestRetrier.swift
//  Data
//
//  Created by ukBook on 1/5/25.
//

import Moya
import Foundation
import Alamofire
import Domain

public final class APIRequestRetrier: Retrier {
   private let tokenManager = TokenManager.shared
    
   public init() {
       super.init { request, session, error, completion in
           if let response = request.task?.response as? HTTPURLResponse {
               completion(.retry)
           } else {
               completion(.doNotRetry)
           }
       }
   }
    
    public override func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        guard let refreshToken = tokenManager.refreshToken else {
            completion(.doNotRetry)
            return
        }
        
        let provider = MoyaProvider<AuthAPI>()
        
        provider.request(.refreshAccessToken(refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .success(let response):
                print("🔥 토큰 재발급")
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                    self?.tokenManager.saveTokens(accessToken: tokenResponse.data.accessToken, refreshToken: tokenResponse.data.refreshToken)
                    
                    if let urlRequest = request.request {
                        // Retry the request with the updated access token
                        session.request(urlRequest).response { _ in
                            print("재요청 성공")
                            completion(.doNotRetry)
                        }
                    }
                } catch {
                    completion(.doNotRetry)
                }
            case .failure:
                completion(.doNotRetry)
            }
        }
    }
}
