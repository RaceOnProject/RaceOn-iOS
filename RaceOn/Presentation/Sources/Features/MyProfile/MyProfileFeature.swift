//
//  MyProfileFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 12/16/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MyProfileFeature {
    struct State: Equatable {
        var nickname: String = ""
        var friendCode: String = "GD231E"
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
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.nickname = "random name"
            return .none
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
        }
    }
}
