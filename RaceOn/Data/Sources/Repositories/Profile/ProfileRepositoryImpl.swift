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

public final class ProfileRepositoryImpl: ProfileRepositoryProtocol {
    private let provider: MoyaProvider<ProfileAPI>
    
    public init(provider: MoyaProvider<ProfileAPI> = MoyaProvider<ProfileAPI>(
        session: Session(interceptor: APIRequestRetrier()),  // 세션과 인터셉터를 명확하게 설정
        plugins: [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))  // 여기에 플러그인도 추가 가능
        ]
    )) {
        self.provider = provider
    }
    
    public func fetchMemberCode() -> AnyPublisher<MemberCode, Error> {
        Future { promise in
            self.provider.request(.fetchMemberCode) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(MemberCode.self, from: response.data)
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
