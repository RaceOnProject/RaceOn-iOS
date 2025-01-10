//
//  NetworkManager.swift
//  Data
//
//  Created by ukseung.dev on 1/8/25.
//

import Moya
import Combine
import Foundation
import Domain

// 싱글톤 네트워크 매니저
final class NetworkManager {
    static let shared = NetworkManager()
    
    private let provider: MoyaProvider<MultiTarget>
    
    private init() {
        self.provider = MoyaProvider<MultiTarget>(
            session: Session(interceptor: APIRequestRetrier.shared),
            plugins: [
                NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
            ]
        )
    }
    
    func request<T: Decodable>(target: TargetType, type: T.Type) -> AnyPublisher<BaseResponse<T>, NetworkError> {
        Future { promise in
            self.provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(BaseResponse<T>.self, from: response.data)
                        
                        if let serverError = decodedResponse.toError() {
                            promise(.failure(.serverDefinedError(serverError.message)))
                        } else {
                            promise(.success(decodedResponse))
                        }
                    } catch {
                        promise(.failure(.decodingError(error)))
                    }
                case .failure(let error):
                    if let response = error.response {
                        do {
                            let decodedResponse = try JSONDecoder().decode(BaseResponse<T>.self, from: response.data)
                            
                            if let serverError = decodedResponse.toError() {
                                promise(.failure(.serverDefinedError(serverError.message)))
                            } else {
                                promise(.success(decodedResponse))
                            }
                        } catch {
                            promise(.failure(.decodingError(error)))
                        }
                    } else {
                        promise(.failure(.networkFailure(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

}
