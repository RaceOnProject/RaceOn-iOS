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
import Shared

public final class APIRequestRetrier: RequestInterceptor {
    public static let shared = APIRequestRetrier()
    private let tokenManager = TokenManager.shared
    public init() {}
    
    private var accessToken: String {
        tokenManager.accessToken ?? .init()
    }
    
    private var refreshToken: String {
        tokenManager.refreshToken ?? .init()
    }
    
    enum Constants {
        static let retryLimit = 1
        static let retryDelay: TimeInterval = 1
    }
    
    // URLRequest를 adapt하는 부분
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
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
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                    self?.tokenManager.saveTokens(
                        accessToken: tokenResponse.data.accessToken,
                        refreshToken: tokenResponse.data.refreshToken
                    )
                    
                    if request.retryCount < Constants.retryLimit {
                        completion(.retryWithDelay(Constants.retryDelay))
                    } else {
                        completion(.doNotRetryWithError(error))
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
