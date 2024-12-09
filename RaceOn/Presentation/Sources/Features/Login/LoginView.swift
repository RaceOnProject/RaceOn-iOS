//
//  LoginView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import Shared

struct LoginView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            CommonConstants.defaultBackgroundColor
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
