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
        var memberInfo: MemberInfo?
        
        var friendCode: String?
        var isEditing: Bool = false
        
        var showImagePicker = false
        var selectedImage: UIImage?
        var isCroppingPresented = false
        
        var isLoading: Bool = false
        
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
        
        case setMemberInfo(MemberInfo)
        case setErrorMessage(String)
        
        case noAction
    }
    
    @Dependency(\.memberUseCase) var memberUseCase
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
//            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { return .none }
            // FIXME: TEST용 (임시 로그인)
            let memberId: Int = 1
            
            return Effect.publisher {
                memberUseCase.fetchMemberInfo(memberId: memberId)
                    .receive(on: DispatchQueue.main)
                    .map {
                        // response에서 data를 추출하여 Action으로 전달
                        if let memberInfo = $0.data {
                            return Action.setMemberInfo(memberInfo)
                        } else {
                            // data가 없는 경우 에러로 처리
                            return Action.setErrorMessage("멤버 정보를 찾을 수 없습니다.")
                        }
                    }
                    .catch { error -> Just<Action> in
                        // 에러를 처리하여 Action.setError로 반환
                        let errorMessage = error.message
                        return Just(Action.setErrorMessage(errorMessage))
                    }
                    .eraseToAnyPublisher()
            }
        case .copyButtonTapped:
            guard let memberInfo = state.memberInfo else { return .none }
            UIPasteboard.general.string = memberInfo.memberCode
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
            
        case .setMemberInfo(let memberInfo):
            dump(memberInfo)
            state.isLoading = false
            state.memberInfo = memberInfo
            return .none
        case .setErrorMessage(let errorMessage):
            state.isLoading = false
            state.setErrorMessage = errorMessage
            return .none
        case .noAction:
            return .none
        }
    }
}
