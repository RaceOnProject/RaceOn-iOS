//
//  AddFriendFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import ComposableArchitecture
import SwiftUI
import Foundation
import Domain
import Data
import Combine

@Reducer
struct AddFriendFeature {
    
    @Dependency(\.friendUseCase) var friendUseCase
    
    struct State: Equatable {
        var toast: Toast?
        var isLoading: Bool = false
        
        var letters: [String] = Array(repeating: "", count: 6)
        
        var totalLetter = ""
        var isButtonEnabled = false
        
        var errorMessage: String?
        
        enum Field: String, Hashable {
            case first, second, third, fourth, fifth, sixth
            
            init?(_ index: Int) {
                switch index {
                case 0: self = .first
                case 1: self = .second
                case 2: self = .third
                case 3: self = .fourth
                case 4: self = .fifth
                case 5: self = .sixth
                default: return nil
                }
            }
        }
    }
    
    enum Action {
        case onAppear
        case willEnterForeground
        case processCopiedText
        case writeLetter(index: Int, text: String)
        case addUpTotalLetter
        case addFriendButtonTapped
        
        case showToast(content: String)
        case dismissToast
        
        case setAddFriendResponse(BaseResponse<VoidResponse>)
        case setErrorMessage(String)
        
        case noAction
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .send(.processCopiedText)
        case .willEnterForeground:
            return .send(.processCopiedText)
        case .processCopiedText:
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
            state.letters[index] = text
            return .send(.addUpTotalLetter)
        case .addUpTotalLetter:
            state.totalLetter = state.letters.reduce("", +)
            state.isButtonEnabled = state.totalLetter.count >= 6 ? true : false
            return .none
        case .addFriendButtonTapped:
            state.isLoading = true
            return Effect.publisher {
                friendUseCase.sendFriendCode(state.totalLetter)
                    .receive(on: DispatchQueue.main)
                    .map {
                        Action.setAddFriendResponse($0)
                    }
                    .catch { error in
                        let errorMessage = error.message
                        return Just(Action.setErrorMessage(errorMessage))
                    }
                    .eraseToAnyPublisher()
            }
        case .showToast(let content):
            state.toast = Toast(content: content)
            return .none
        case .dismissToast:
            state.toast = nil
            return .none
        case .setAddFriendResponse(let response):
            state.isLoading = false
            return .none
        case .setErrorMessage(let errorMessage):
            state.isLoading = false
            state.errorMessage = errorMessage
            return .none
        case .noAction:
            return .none
        }
    }
}
