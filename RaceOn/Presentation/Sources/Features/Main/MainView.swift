//
//  MainView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import Shared

struct MainView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            CommonConstants.defaultBackgroundColor
                .ignoresSafeArea()
            VStack {
                Text("MainView")
                    .foregroundColor(.white)
                    .font(.light(20)) // Pretendard-Light, 20pt
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
        .environmentObject(Router())
}
