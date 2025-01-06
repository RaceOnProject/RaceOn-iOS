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

@Reducer
struct MyProfileFeature {
    struct State: Equatable {
        var nickname: String = ""
        var friendCode: String?
        var isEditing: Bool = false
        
        var showImagePicker = false
        var selectedImage: UIImage?
        var isCroppingPresented = false
        
        var toast: Toast?
    }
    
    enum Action {
        case onAppear
        case copyButtonTapped
        case enterEditMode(isEditing: Bool)
        case dismissToast
        
        case setImagePickerPresented(isPresented: Bool)
        case setSelectedImage(image: UIImage)
        case setIsCroppingPresented(isPresented: Bool)
        
        case setNickname(String)  // nickname을 업데이트하는 액션
        case setError(String)  // 오류 메시지를 설정하는 액션
    }
    
    @Dependency(\.memberUseCase) var memberUseCase
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.nickname = "random name"
            
//            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { return .none }
            // TODO: TEST 용(임시 로그인)
            let memberId: Int = 1
            
            return Effect.publisher {
                memberUseCase.fetchMemberCode(memberId: memberId)
                    .receive(on: DispatchQueue.main)
                    .map {
                        Action.setNickname($0.data.memberCode)
                    }
                    .catch { error in
                        Just(Action.setError(error.localizedDescription))
                    }
                    .eraseToAnyPublisher()
            }
        case .copyButtonTapped:
            UIPasteboard.general.string = state.friendCode
            state.toast = Toast(content: "내 코드가 복사되었어요")
            return .none
        case .enterEditMode(let isEditing):
            state.isEditing = isEditing
            return .none
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
            
        case .setNickname(let code):
            state.friendCode = code
            return .none
        case .setError(let errorMessage):
            state.friendCode = errorMessage // 오류 메시지를 상태에 반영 (예시)
            return .none
        }
    }
}
