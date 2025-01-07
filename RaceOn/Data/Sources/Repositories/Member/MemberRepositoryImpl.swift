//
//  ProfileRepositoryImpl.swift
//  Data
//
//  Created by ukseung.dev on 12/27/24.
//

import Moya
import Domain
import ComposableArchitecture
import Foundation
import Combine
import Alamofire

public final class MemberRepositoryImpl: MemberRepositoryProtocol {
    private let provider: MoyaProvider<MemberAPI>
    
    public init(provider: MoyaProvider<MemberAPI> = MoyaProvider<MemberAPI>(
        session: Session(interceptor: APIRequestRetrier.shared),  // 세션과 인터셉터를 명확하게 설정
        plugins: [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))  // 여기에 플러그인도 추가 가능
        ]
    )) {
        self.provider = provider
    }
    
    public func fetchMemberInfo(memberId: Int) -> AnyPublisher<MemberInfo, Error> {
        Future { promise in
            self.provider.request(.fetchMemberInfo(memberId: memberId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(MemberInfo.self, from: response.data)
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
    
    public func deleteAccount(memberId: Int) -> AnyPublisher<BaseResponse, any Error> {
        Future { promise in
            self.provider.request(.deleteAccount(memberId: memberId)) { result in
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
