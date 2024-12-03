//
//  LoginView.swift
//  Presentation
//
//  Created by 박시현 on 12/4/24.
//

import Foundation
import SwiftUI

enum SocialLoginType {
    case apple
    case kakao
    
    var title: String {
        switch self {
        case .apple: return "Continue with Apple"
        case .kakao: return "카카오로 로그인"
        }
    }
    
    var image: String {
        switch self {
        case .apple: return "appleLogo"
        case .kakao: return "kakaoLogo"
        }
    }
}

public struct LoginView: View {
    public init() {}
    
    private func loginButton(
        type: SocialLoginType,
        action: @escaping () -> Void
    ) -> some View {
        let backgroundColor: Color = type == .kakao ? Color(hex: "FEE500") : .black
        let textColor: Color = type == .kakao ? .black : .white
        
        return Rectangle()
            .foregroundStyle(backgroundColor)
            .frame(width: 350, height: 54)
            .overlay {
                HStack {
                    Image(type.image)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(.leading, 20)
                    Button(type.title, action: action)
                        .foregroundStyle(textColor)
                }
            }
            .cornerRadius(30)
            .padding(.bottom, 12)
    }
    
    public var body: some View {
        VStack {
            Image("loginMainImage1")
                .resizable()
                .frame(width: 280, height: 100)
                .padding(.top, 130)
            
            Image("loginMainImage2")
                .resizable()
                .frame(width: 320, height: 224)
            
            Spacer()
            
            loginButton(type: .kakao) {
                // 카카오 로그인 액션
            }
            
            loginButton(type: .apple) {
                // 애플 로그인 액션
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.indigo)
    }
}
