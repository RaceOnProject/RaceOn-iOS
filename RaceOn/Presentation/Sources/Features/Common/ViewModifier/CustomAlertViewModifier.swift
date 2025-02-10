//
//  CustomAlertViewModifier.swift
//  Presentation
//
//  Created by ukBook on 2/1/25.
//

import SwiftUI

public enum CustomAlertType {
    case invite(nickname: String)
    case stop(nickname: String)
    
    var title: String {
        switch self {
        case .invite(let nickname): return "\(nickname) 님이\n경쟁에 초대했어요 🏃🏻‍♂️"
        case .stop(let nickname): return "\(nickname) 님이\n경쟁 중단을 요청했어요"
        }
    }
    
    var centerImage: Image {
        switch self {
        case .invite: return ImageConstants.graphicInvite
        case .stop: return ImageConstants.graphicStop
        }
    }
    
    var imageFrame: (CGFloat, CGFloat) {
        switch self {
        case .invite: return (154, 140)
        case .stop: return (120, 120)
        }
    }
    
    var presentButtonTitle: String {
        switch self {
        case .invite: return "초대 수락"
        case .stop: return "경쟁 종료하기"
        }
    }
    
    var dismissButtonTitle: String {
        switch self {
        case .invite: return "다음에 경쟁할게요"
        case .stop: return "취소"
        }
    }
}

struct CustomAlertViewModifier: ViewModifier {
    let isPresented: Bool
    let alertType: CustomAlertType
    let presentAction: () -> Void
    let dismissAction: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    VStack {
                        Text(alertType.title)
                            .multilineTextAlignment(.center)
                            .lineSpacing(5.0)
                            .padding(.vertical, 20)
                            .font(.semiBold(20))
                            .foregroundColor(.white)
                        
                        alertType.centerImage
                            .frame(width: alertType.imageFrame.0, height: alertType.imageFrame.1)
                            .padding(.bottom, 20)
                        
                        Button(action: presentAction) {
                            Text(alertType.presentButtonTitle)
                                .frame(width: 260, height: 30)
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .cornerRadius(30)
                        }
                        
                        Button(action: dismissAction) {
                            Text(alertType.dismissButtonTitle)
                                .font(.regular(17))
                                .foregroundColor(ColorConstants.gray3)
                                .padding()
                        }
                    }
                    .frame(width: 300, height: 400)
                    .padding()
                    .background(ColorConstants.gray5)
                    .cornerRadius(24)
                    .shadow(radius: 20)
                    Spacer()
                }
                .padding()
            }
        }
    }
}

extension View {
    func customAlert(
        isPresented: Bool,
        alertType: CustomAlertType,
        presentAction: @escaping () -> Void,
        dismissAction: @escaping () -> Void
    ) -> some View {
        self.modifier(
            CustomAlertViewModifier(
                isPresented: isPresented,
                alertType: alertType,
                presentAction: presentAction,
                dismissAction: dismissAction
            )
        )
    }
}
