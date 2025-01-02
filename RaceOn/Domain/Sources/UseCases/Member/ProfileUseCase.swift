//
//  ProfileUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import ComposableArchitecture
import Combine

public protocol ProfileUseCaseProtocol {
    func fetchMemberCode() -> AnyPublisher<MemberCode, Error>
}

public final class ProfileUseCase: ProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchMemberCode() -> AnyPublisher<MemberCode, Error> {
        repository.fetchMemberCode()
    }
}
