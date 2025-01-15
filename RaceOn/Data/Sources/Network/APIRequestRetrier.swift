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
        static let urlString: String = "https://s3.ap-northeast-2.amazonaws.com/race-on/profileimage"
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let absoluteString = urlRequest.url?.absoluteString else {
            return
        }
        
        var urlRequest = urlRequest
        absoluteString.contains(Constants.urlString) ? nil : urlRequest.headers.add(.authorization(bearerToken: accessToken)) // S3에 업로드할때는 토큰 제거
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
        
        let provider = MoyaProvider<AuthAPI>(plugins: [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ])
        
        provider.request(.refreshAccessToken(refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(BaseResponse<TokenResponse>.self, from: response.data)
                    self?.tokenManager.saveTokens(
                        accessToken: response.data?.accessToken ?? "",
                        refreshToken: response.data?.refreshToken ?? ""
                    )
                    
                    if request.retryCount < Constants.retryLimit {
                        completion(.retry)
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
