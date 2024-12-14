//
//  LoginView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import Shared

public struct LoginView: View {
    public init() {}
    @EnvironmentObject var router: Router
    
    public var body: some View {
        ZStack {
            ColorConstants.gray6
                .ignoresSafeArea()
            VStack {
                Text("LoginView")
                    .foregroundColor(.white)
                    .font(.bold(25)) // Pretendard-Bold, 25pt
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
        .environmentObject(Router())
}
