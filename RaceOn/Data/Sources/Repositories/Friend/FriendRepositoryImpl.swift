//
//  FriendRepositoryImpl.swift
//  Data
//
//  Created by ukseung.dev on 1/2/25.
//

import Moya
import Domain
import ComposableArchitecture
import Foundation
import Combine
import Alamofire

public final class FriendRepositoryImpl: FriendRepositoryProtocol {
    private let provider: MoyaProvider<FriendAPI>
    
    public init(provider: MoyaProvider<FriendAPI> = MoyaProvider<FriendAPI>(
        session: Session(interceptor: APIRequestRetrier.shared), // AuthInterceptor를 Session에 추가
        plugins: [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
    )) {
        self.provider = provider
    }
    
    public func sendFriendCode(_ code: String) -> AnyPublisher<BaseResponse, any Error> {
        Future { promise in
            self.provider.request(.sendFriendCode(code: code)) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(BaseResponse.self, from: response.data)
                        promise(.success(response))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func fetchFriendList() -> AnyPublisher<FriendResponse, any Error> {
        Future { promise in
            self.provider.request(.fetchFriendList) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(FriendResponse.self, from: response.data)
                        promise(.success(response))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func reportFriend(memberId: Int) -> AnyPublisher<BaseResponse, any Error> {
        Future { promise in
            self.provider.request(.reportFriend(memberId: memberId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(BaseResponse.self, from: response.data)
                        promise(.success(response))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func unFriend(memberId: Int) -> AnyPublisher<Domain.BaseResponse, any Error> {
        Future { promise in
            self.provider.request(.unFriend(memberId: memberId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(BaseResponse.self, from: response.data)
                        promise(.success(response))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
