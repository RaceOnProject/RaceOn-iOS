//
//  AddFriendFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import ComposableArchitecture
import SwiftUI
import Foundation

@Reducer
struct AddFriendFeature {
    struct State: Equatable {
        var toast: Toast?
        
        var firstLetter: String = ""
        var secondLetter: String = ""
        var thirdLetter: String = ""
        var fourthLetter: String = ""
        var fifthLetter: String = ""
        var sixthLetter: String = ""
        
        var totalLetter = ""
        var isButtonEnabled = false
        
        enum Field: String, Hashable {
            case first
            case second
            case third
            case fourth
            case fifth
            case sixth
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case writeLetter(index: Int, text: String)
        case addUpTotalLetter
        case addFriendButtonTapped
        
        case showToast(content: String)
        case dismissToast
        
        case noAction
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            if let copiedText = UIPasteboard.general.string?.uppercased() {
                print("복사 한 문자 => \(copiedText)")
                
                if copiedText.count == 6 {
                    let textArr = copiedText.compactMap { String($0) }

                    return .run { send in
                        for (index, letter) in textArr.enumerated() {
                            await send(.writeLetter(index: index, text: letter))
                        }
                    }
                }
            }
            return .none
        case .writeLetter(let index, let text):
            guard (0...5).contains(index) else { return .none }
                switch index {
                case 0: state.firstLetter = text
                case 1: state.secondLetter = text
                case 2: state.thirdLetter = text
                case 3: state.fourthLetter = text
                case 4: state.fifthLetter = text
                case 5: state.sixthLetter = text
                default: break
                }
            return .send(.addUpTotalLetter)
        case .addUpTotalLetter:
            state.totalLetter = state.firstLetter + state.secondLetter + state.thirdLetter + state.fourthLetter + state.fifthLetter + state.sixthLetter
            state.isButtonEnabled = state.totalLetter.count >= 6 ? true : false
            return .none
        case .addFriendButtonTapped:
            print("\(state.totalLetter)")
            return .send(.showToast(content: "친구 추가하기 완료(테스트, API 연동 안됨)"))
        case .showToast(let content):
            state.toast = Toast(content: content)
            return .none
        case .dismissToast:
            state.toast = nil
            return .none
        case .noAction:
            return .none
        }
    }
}
