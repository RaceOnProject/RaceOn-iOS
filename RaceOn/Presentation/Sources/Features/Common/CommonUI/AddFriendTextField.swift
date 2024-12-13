//
//  AddFriendTextField.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import SwiftUI

struct AddFriendTextField: View {
    enum Constants {
        static let maxLength = 1 // 최대 글자 수
    }
    
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .onChange(of: text) { newValue in
                let upperCased = newValue.uppercased()
                // 최대 글자 수 초과 시 잘라내기
                if upperCased.count > Constants.maxLength {
                    text = String(upperCased.prefix(Constants.maxLength))
                } else {
                    text = upperCased
                }
            }
            .font(.bold(24))
            .foregroundColor(.white)
            .multilineTextAlignment(.center) // 텍스트 가운데 정렬
            .frame(height: 66)
    }
}

#Preview {
    @State var text: String = ""
    
    return AddFriendTextField(
        text: $text
    )
}
