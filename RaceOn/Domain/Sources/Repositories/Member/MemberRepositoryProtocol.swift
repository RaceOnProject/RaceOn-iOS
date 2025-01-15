//
//  MemberRepositoryProtocol.swift
//  Domain
//
//  Created by ukseung.dev on 12/27/24.
//

import Combine
import Foundation
import Moya

public protocol MemberRepositoryProtocol {
    func fetchMemberInfo(memberId: Int) -> AnyPublisher<BaseResponse<MemberInfo>, NetworkError>
    func deleteAccount(memberId: Int) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
    func requestImageEditPermission(memberId: Int) -> AnyPublisher<BaseResponse<ProfileImageResponse>, NetworkError>
    func uploadImageS3(url: String, pngData: Data) -> AnyPublisher<Void, NetworkError>
    func updateProfile(memberId: Int, contentUrl: String, nickname: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError>
}
