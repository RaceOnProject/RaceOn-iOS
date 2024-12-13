//
//  FriendFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import Foundation
import ComposableArchitecture

struct TestData: Equatable, Identifiable {
    let id = UUID() // 고유 식별자
    var index: Int
}

@Reducer
struct FriendFeature {
    struct State: Equatable {
        var tData: [TestData] = []
        var isActionSheetPresented: Bool = false
    }
    
    enum Action: Equatable {
        case testAction
        case kebabButtonTapped
        case dismissActionSheet
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .testAction:
            for x in 0 ..< 10 {
                state.tData.append(TestData(index: x))
            }
            return .none
        case .kebabButtonTapped:
            print("FriendFeature kebabButtonTapped")
            state.isActionSheetPresented = true
            return .none
        case .dismissActionSheet:
            // ActionSheet dismiss 처리
            state.isActionSheetPresented = false
            return .none
        }
    }
}
