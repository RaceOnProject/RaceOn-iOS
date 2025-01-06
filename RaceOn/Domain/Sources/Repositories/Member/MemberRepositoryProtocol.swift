//
//  MemberRepositoryProtocol.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import Combine

public protocol MemberRepositoryProtocol {
    func fetchMemberCode(memberId: Int) -> AnyPublisher<MemberCode, Error>
    func deleteAccount(memberId: Int) -> AnyPublisher<CommonResponse, any Error>
}
