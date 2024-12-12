//
//  ToastView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/12/24.
//

import SwiftUI
import Shared

struct ToastView: View {
    enum Constants {
        static let backgroundColor = PresentationAsset.gray5.swiftUIColor
        static let toastIconImage = PresentationAsset.circleExclamationMark.swiftUIImage
    }
    
    var type: ToastStyle
    var content: String
    var body: some View {
        HStack(alignment: .center) {
            Constants.toastIconImage
            
                Text(content)
                    .font(.semiBold(15))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Constants.backgroundColor)
            .cornerRadius(30)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}

#Preview {
    ToastView(
        type: .info,
        content: "유효하지 않은 코드 입니다."
    )
}
