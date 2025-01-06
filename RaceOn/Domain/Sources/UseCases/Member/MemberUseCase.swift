//
//  MemberUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import ComposableArchitecture
import Combine

public protocol MemberUseCaseProtocol {
    func fetchMemberInfo(memberId: Int) -> AnyPublisher<MemberInfo, Error>
    func deleteAccount(memberId: Int) -> AnyPublisher<CommonResponse, Error>
}

public final class MemberUseCase: MemberUseCaseProtocol {
    private let repository: MemberRepositoryProtocol
    
    public init(repository: MemberRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchMemberInfo(memberId: Int) -> AnyPublisher<MemberInfo, Error> {
        repository.fetchMemberInfo(memberId: memberId)
    }
    
    public func deleteAccount(memberId: Int) -> AnyPublisher<CommonResponse, any Error> {
        repository.deleteAccount(memberId: memberId)
    }
}
