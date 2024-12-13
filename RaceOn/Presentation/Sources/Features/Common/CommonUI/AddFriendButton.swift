//
//  AddFriendButton.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import SwiftUI

struct AddFriendButton: View {
    
    @Binding var isButtonEnabled: Bool
    var onButtonTapped: () -> Void // 버튼이 눌렸을 때 실행될 클로저
    
    var body: some View {
        Button {
            onButtonTapped()
        } label: {
            Text("친구 추가하기")
                .font(.semiBold(17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 54) // 버튼의 높이 설정
        .background(isButtonEnabled ? ColorConstants.primaryNormal : ColorConstants.gray4)
        .cornerRadius(30) // 버튼의 모서리 둥글게 설정
        .padding(.horizontal, 20) // 좌우 여백 추가
    }
}

#Preview {
    @State var isButtonEnabled: Bool = false
    return AddFriendButton(
        isButtonEnabled: $isButtonEnabled) {
            print("친구 추가하기")
        }
}
