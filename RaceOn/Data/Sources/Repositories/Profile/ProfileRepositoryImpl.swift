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

public final class ProfileRepositoryImpl: ProfileRepositoryProtocol {
    private let provider: MoyaProvider<ProfileAPI>
    
    public init(provider: MoyaProvider<ProfileAPI> = MoyaProvider<ProfileAPI>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }
    
    public func fetchMemberCode() -> AnyPublisher<MemberCode, Error> {
        Future { promise in
            self.provider.request(.fetchMemberCode) { result in
                switch result {
                case .success(let response):
                    do {
                        let memberCode = try JSONDecoder().decode(MemberCode.self, from: response.data)
                        promise(.success(memberCode))
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
