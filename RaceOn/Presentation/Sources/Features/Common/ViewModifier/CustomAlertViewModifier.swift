//
//  CustomAlertViewModifier.swift
//  Presentation
//
//  Created by ukBook on 2/1/25.
//


import SwiftUI

struct CustomAlertViewModifier: ViewModifier {
    let isPresented: Bool
    let title: String
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
                        Text(title)
                            .multilineTextAlignment(.center)
                            .lineSpacing(5.0)
                            .padding(.vertical, 20)
                            .font(.semiBold(20))
                            .foregroundColor(.white)
                        
                        ImageConstants.graphicInvite
                            .frame(width: 154, height: 140)
                            .padding(.bottom, 20)
                        
                        Button(action: presentAction) {
                            Text("초대 수락")
                                .frame(width: 260, height: 30)
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .cornerRadius(30)
                        }
                        
                        Button(action: dismissAction) {
                            Text("다음에 경쟁할게요")
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
        title: String,
        presentAction: @escaping () -> Void,
        dismissAction: @escaping () -> Void
    ) -> some View {
        self.modifier(
            CustomAlertViewModifier(
                isPresented: isPresented,
                title: title,
                presentAction: presentAction,
                dismissAction: dismissAction
            )
        )
    }
}
