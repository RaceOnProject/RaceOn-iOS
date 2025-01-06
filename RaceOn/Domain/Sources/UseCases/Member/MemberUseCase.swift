//
//  MemberUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import ComposableArchitecture
import Combine

public protocol MemberUseCaseProtocol {
    func fetchMemberCode(memberId: Int) -> AnyPublisher<MemberCode, Error>
    func deleteAccount(memberId: Int) -> AnyPublisher<CommonResponse, Error>
}

public final class MemberUseCase: MemberUseCaseProtocol {
    private let repository: MemberRepositoryProtocol
    
    public init(repository: MemberRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchMemberCode(memberId: Int) -> AnyPublisher<MemberCode, Error> {
        repository.fetchMemberCode(memberId: memberId)
    }
    
    public func deleteAccount(memberId: Int) -> AnyPublisher<CommonResponse, any Error> {
        repository.deleteAccount(memberId: memberId)
    }
}
