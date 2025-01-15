//
//  MemberUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import Foundation
import ComposableArchitecture
import Combine
import Moya

public protocol MemberUseCaseProtocol {
    func fetchMemberInfo(memberId: Int) -> AnyPublisher<BaseResponse<MemberInfo>, NetworkError>
    func deleteAccount(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
    func requestImageEditPermission(memberId: Int) -> AnyPublisher<BaseResponse<ProfileImageResponse>, NetworkError>
    func uploadImageS3(url: String, pngData: Data) -> AnyPublisher<Void, NetworkError>
    func updateProfile(memberId: Int, contentUrl: String, nickname: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
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
    
    public func requestImageEditPermission(memberId: Int) -> AnyPublisher<BaseResponse<ProfileImageResponse>, NetworkError> {
        return repository.requestImageEditPermission(memberId: memberId)
    }
    
    public func uploadImageS3(url: String, pngData: Data) -> AnyPublisher<Void, NetworkError> {
        return repository.uploadImageS3(url: url, pngData: pngData)
    }
    
    public func updateProfile(memberId: Int, contentUrl: String, nickname: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return repository.updateProfile(memberId: memberId, contentUrl: contentUrl, nickname: nickname)
    }
}
