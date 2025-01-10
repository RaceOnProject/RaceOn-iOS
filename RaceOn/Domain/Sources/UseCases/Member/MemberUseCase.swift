//
//  MemberUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import ComposableArchitecture
import Combine

public protocol MemberUseCaseProtocol {
    func fetchMemberInfo(memberId: Int) -> AnyPublisher<BaseResponse<MemberInfo>, NetworkError>
    func deleteAccount(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
}

public final class MemberUseCase: MemberUseCaseProtocol {
    private let repository: MemberRepositoryProtocol
    
    public init(repository: MemberRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchMemberInfo(memberId: Int) -> AnyPublisher<BaseResponse<MemberInfo>, NetworkError> {
        return repository.fetchMemberInfo(memberId: memberId)
    }
    
    public func deleteAccount(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return repository.deleteAccount(memberId: memberId)
    }
}
