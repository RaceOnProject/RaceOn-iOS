//
//  ProfileRepositoryProtocol.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import Combine

public protocol ProfileRepositoryProtocol {
    func fetchMemberCode() -> AnyPublisher<MemberCode, Error>
}
