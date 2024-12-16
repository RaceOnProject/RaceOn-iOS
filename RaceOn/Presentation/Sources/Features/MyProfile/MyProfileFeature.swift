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
        var friendCode: String = "GD231E"
        var toast: Toast?
    }
    
    enum Action {
        case copyButtonTapped
        case dismissToast
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .copyButtonTapped:
            UIPasteboard.general.string = state.friendCode
            state.toast = Toast(content: "내 코드가 복사되었어요")
            return .none
        case .dismissToast:
            state.toast = nil
            return .none
        }
    }
}
