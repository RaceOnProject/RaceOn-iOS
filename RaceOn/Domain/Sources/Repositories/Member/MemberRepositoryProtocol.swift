//
//  MemberRepositoryProtocol.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import Combine

public protocol MemberRepositoryProtocol {
    func fetchMemberInfo(memberId: Int) -> AnyPublisher<MemberInfo, Error>
    func deleteAccount(memberId: Int) -> AnyPublisher<BaseResponse, any Error>
}
