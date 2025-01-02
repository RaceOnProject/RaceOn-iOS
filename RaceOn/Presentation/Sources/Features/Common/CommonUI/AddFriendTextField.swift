//
//  AddFriendTextField.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import SwiftUI

struct AddFriendTextField: UIViewRepresentable {
    @Binding var text: String
    var onDeleteBackward: (() -> Void)?
    var maxLength: Int = 1

    func makeUIView(context: Context) -> UITextField {
        let textField = CustomUITextField()
        textField.delegate = context.coordinator
        textField.text = text
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.textAlignment = .center
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.tintColor = .clear // 커서 색을 투명하게 설정
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textDidChange),
            for: .editingChanged
        )
        textField.onDeleteBackward = onDeleteBackward
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
        // 포커스가 갈 때 커서를 텍스트 끝으로 이동
        let endPosition = uiView.endOfDocument
        if uiView.isFirstResponder {
            uiView.selectedTextRange = uiView.textRange(from: endPosition, to: endPosition)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: AddFriendTextField

        init(_ parent: AddFriendTextField) {
            self.parent = parent
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // 포커스가 갈 때 커서를 텍스트 끝으로 이동
            
            let endPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        }

        @objc func textDidChange(_ textField: UITextField) {
            // 대문자로 변환 및 텍스트 업데이트
            if let text = textField.text {
                let upperCased = text.uppercased()
                if upperCased.count > parent.maxLength {
                    if let lastCharacter = upperCased.last {
                        textField.text = String(lastCharacter)
                    }
                } else {
                    textField.text = upperCased
                }
                parent.text = textField.text ?? ""
            }
        }
    }
}

class CustomUITextField: UITextField {
    var onDeleteBackward: (() -> Void)?
    var onCharacterEmitted: ((String) -> Void)? // 특정 문자 방출 클로저

    override func deleteBackward() {
        if text?.isEmpty ?? true {
            onDeleteBackward?()
        }
        super.deleteBackward()
    }
}

#Preview {
    @State var text: String = ""
    
    return AddFriendTextField(
        text: $text,
        onDeleteBackward: {
            print("Delete")
        }
    )
    .border(.black, width: 1)
}
