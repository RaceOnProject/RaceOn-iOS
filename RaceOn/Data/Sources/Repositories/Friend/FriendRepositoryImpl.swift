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

public final class FriendRepositoryImpl: FriendRepositoryProtocol {
    private let provider: MoyaProvider<FriendAPI>
    
    public init(provider: MoyaProvider<FriendAPI> = MoyaProvider<FriendAPI>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }
    
    public func sendFriendCode(_ code: String) -> AnyPublisher<AddFriendResponse, any Error> {
        Future { promise in
            self.provider.request(.sendFriendCode(code: code)) { result in
                switch result {
                case .success(let response):
                    do {
                        let result = try JSONDecoder().decode(AddFriendResponse.self, from: response.data)
                        promise(.success(result))
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
                        let result = try JSONDecoder().decode(FriendResponse.self, from: response.data)
                        promise(.success(result))
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
