//
//  MyProfileFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 12/16/24.
//

import ComposableArchitecture
import SwiftUI
import Domain
import Data
import Combine
import Shared
import Moya

@Reducer
struct MyProfileFeature {
    struct State: Equatable {
        var profileImageUrl: String?
        var originalNickname: String?
        var nickname: String?
        var memberCode: String?
        var isEditing: Bool = false
        
        var showImagePicker = false
        var selectedImage: UIImage?
        var isCroppingPresented = false
        
        var isLoading: Bool = false
        var errorMessage: String?
        var toast: Toast?
    }
    
    enum Action {
        case onAppear
        case copyButtonTapped
        
        case editButtonTapped
        case saveButtonTapped
        case uploadImageS3(BaseResponse<ProfileImageResponse>)
        
        case editProfile
        
        case dismissToast
        
        case setImagePickerPresented(isPresented: Bool)
        case setSelectedImage(image: UIImage)
        case setIsCroppingPresented(isPresented: Bool)
        
        case setMemberInfo(MemberInfo)
        case editProfileResponse
        case setErrorMessage(String)
        
        case editNickname(String)
        
        case logout
    }
    
    @Dependency(\.memberUseCase) var memberUseCase
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else {
                return .send(.logout)
            }
            return fetchMemberInfo(memberId: memberId)
        case .copyButtonTapped:
            guard let memberCode = state.memberCode else { return .none }
            UIPasteboard.general.string = memberCode
            state.toast = Toast(content: "내 코드가 복사되었어요")
            return .none
        case .editButtonTapped:
            state.isEditing = true
            return .none
        case .saveButtonTapped:
            state.isLoading = true
            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else {
                return .send(.logout)
            }
            return requestImageEditPermission(memberId: memberId)
        case .uploadImageS3(let response):
            return handleUploadImageS3(response: response, state: &state)
        case .editProfile:
            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else {
                return .send(.logout)
            }
            return updateProfile(memberId: memberId, state: &state)
        case .dismissToast:
            state.toast = nil
            return .none
        case .setImagePickerPresented(let isPresented):
            state.showImagePicker = isPresented
            return .none
        case .setSelectedImage(let image):
            state.selectedImage = image
            return .none
        case .setIsCroppingPresented(let isPresented):
            state.isCroppingPresented = isPresented
            return .none
        case .setMemberInfo(let memberInfo):
            state.profileImageUrl = memberInfo.profileImageUrl
            state.originalNickname = memberInfo.nickname
            state.nickname = memberInfo.nickname
            state.memberCode = memberInfo.memberCode
            state.isLoading = false
            return .none
        case .editProfileResponse:
            state.isLoading = false
            state.isEditing = false
            return .none
        case .setErrorMessage(let errorMessage):
            state.errorMessage = errorMessage
            state.isLoading = false
            return .none
        case .editNickname(let nickname):
            state.nickname = nickname
            return .none
        case .logout:
            // TODO: Logout
            return .none
        }
    }
    
    private func fetchMemberInfo(memberId: Int) -> Effect<Action> {
        return Effect.publisher {
            memberUseCase.fetchMemberInfo(memberId: memberId)
                .receive(on: DispatchQueue.main)
                .map {
                    if let memberInfo = $0.data {
                        return Action.setMemberInfo(memberInfo)
                    } else {
                        return Action.setErrorMessage("멤버 정보를 찾을 수 없습니다.")
                    }
                }
                .catch { error -> Just<Action> in
                    let errorMessage = error.message
                    return Just(Action.setErrorMessage(errorMessage))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func requestImageEditPermission(memberId: Int) -> Effect<Action> {
        return Effect.publisher {
            memberUseCase.requestImageEditPermission(memberId: memberId)
                .receive(on: DispatchQueue.main)
                .map { Action.uploadImageS3($0) }
                .catch { error in Just(Action.setErrorMessage(error.message)) }
        }
    }
    
    private func handleUploadImageS3(response: BaseResponse<ProfileImageResponse>, state: inout State) -> Effect<Action> {
        if let selectedImage = state.selectedImage,
           let contentUrl = response.data?.contentUrl,
           let imageData = resizeImage(
            image: selectedImage,
            targetSize: CGSize(width: 128, height: 128)
           ).pngData() {
            state.profileImageUrl = contentUrl
            
            return Effect.publisher {
                memberUseCase.uploadImageS3(
                    url: response.data?.preSignedUrl ?? .init(),
                    pngData: imageData
                )
                .receive(on: DispatchQueue.main)
                .map { _ in Action.editProfile }
                .catch { error in Just(Action.setErrorMessage(error.message)) }
            }
        } else {
            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else {
                return .send(.logout)
            }
            return updateProfile(memberId: memberId, state: &state)
        }
    }
    
    private func updateProfile(memberId: Int, state: inout State) -> Effect<Action> {
        guard let nickname = state.nickname, let contentUrl = state.profileImageUrl else {
            return .none
        }
        
        return Effect.publisher {
            memberUseCase.updateProfile(
                memberId: memberId,
                contentUrl: contentUrl,
                nickname: nickname
            )
            .receive(on: DispatchQueue.main)
            .map { _ in Action.editProfileResponse }
            .catch { error in Just(Action.setErrorMessage(error.message)) }
        }
    }
    
    /// UIImage를 지정된 크기로 리사이징하는 함수
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // 크기를 유지하면서 리사이징 비율을 계산합니다
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // 리사이징 후 새 이미지를 생성합니다
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        image.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
}
