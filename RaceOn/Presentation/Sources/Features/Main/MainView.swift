//
//  MainView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import Shared

public struct MainView: View {
    public init() {}
    @EnvironmentObject var router: Router
    
    public var body: some View {
        ZStack {
            ColorConstants.gray6
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
