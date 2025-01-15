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
    
    public func requestImageEditPermission(memberId: Int) -> AnyPublisher<BaseResponse<ProfileImageResponse>, NetworkError> {
        return networkManager.request(
            target: MemberAPI.requestImageEditPermission(memberId: memberId),
            type: ProfileImageResponse.self
        )
    }
    
    public func uploadImageS3(url: String, pngData: Data) -> AnyPublisher<Void, NetworkError> {
        return networkManager.uploadImageToS3(
            target: MemberAPI.uploadImageS3(url: url, pngData: pngData)
        )
    }
    
    public func updateProfile(memberId: Int, contentUrl: String, nickname: String) -> AnyPublisher<BaseResponse<VoidResponse>, NetworkError> {
        return networkManager.request(
            target: MemberAPI.updateProfile(memberId: memberId, contentUrl: contentUrl, nickname: nickname),
            type: VoidResponse.self
        )
    }
}
