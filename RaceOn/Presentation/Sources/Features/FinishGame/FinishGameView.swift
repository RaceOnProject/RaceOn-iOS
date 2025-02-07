//
//  FinishGameView.swift
//  Presentation
//
//  Created by ukBook on 1/28/25.
//

import SwiftUI

public struct FinishGameView: View {
    @EnvironmentObject var router: Router
    
    public var body: some View {
        ZStack {
            // 이겼을때
            LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .init(red: 50, green: 61, blue: 22, alpha: 1), location: 0),
                    Gradient.Stop(color: .init(red: 18, green: 18, blue: 18, alpha: 1), location: 0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // 졌을때
//            LinearGradient(
//                gradient: Gradient(stops: [
//                    Gradient.Stop(color: .init(red: 62, green: 26, blue: 22, alpha: 1), location: 0),
//                    Gradient.Stop(color: .init(red: 18, green: 18, blue: 18, alpha: 1), location: 0.4)
//                ]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
            
            VStack {
                topView
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    var topView: some View {
        HStack() {
            Circle()
                .frame(width: 70, height: 70)
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                Text("레이스 승리!")
                Text("00km 차이로 이겼어요 💫")
            }
            .padding(.leading, 20)
        }
        .padding(.top, 20)
    }
}

#Preview {
    FinishGameView()
}
