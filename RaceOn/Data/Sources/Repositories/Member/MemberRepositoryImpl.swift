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
    public init() {}
    let networkManager: NetworkManager = NetworkManager.shared
    
    public func fetchMemberInfo(memberId: Int) -> AnyPublisher<BaseResponse<MemberInfo>, NetworkError> {
        return networkManager.request(
            target: MemberAPI.fetchMemberInfo(memberId: memberId),
            type: MemberInfo.self
        )
    }
    
    public func deleteAccount(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return networkManager.request(
            target: MemberAPI.deleteAccount(memberId: memberId),
            type: VoidResponse.self
        )
    }
}
