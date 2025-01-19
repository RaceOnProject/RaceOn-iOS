//
//  GameView.swift
//  Presentation
//
//  Created by ukBook on 1/19/25.
//

import Foundation
import SwiftUI
import NMapsMap

public struct GameView: View {
    @EnvironmentObject var router: Router
//    @State private var region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // 샌프란시스코 좌표
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        )
    
    public var body: some View {
        ZStack {
            ColorConstants.gray6.ignoresSafeArea()
            
            VStack {
                mapView
                
                Spacer()
                    .frame(height: 15)
                
                gameDescriptionView
                
                Spacer()
                    .frame(height: 37)
                
                gameStopButton
                
                Spacer()
                    .frame(height: 18)
            }
        }
    }
    
    @ViewBuilder
    var mapView: some View {
        VStack {
            Text("asd")
        }
    }
    
    @ViewBuilder
    var gameDescriptionView: some View {
        HStack(spacing: 30) {
            // 남은 거리
            VStack {
                Text("남은 거리")
                    .font(.semiBold(15))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                Text("0.00 km")
                    .font(.bold(24))
                    .foregroundColor(.white)
            }
            
            // 평균 페이스
            VStack {
                Text("평균 페이스")
                    .font(.semiBold(15))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                Text("16′12″")
                    .font(.bold(24))
                    .foregroundColor(.white)
            }
            
            // 진행 시간
            VStack {
                Text("진행 시간")
                    .font(.semiBold(15))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                Text("00:00:00")
                    .font(.bold(24))
                    .foregroundColor(.white)
            }
        }
    }
    
    @ViewBuilder
    var gameStopButton: some View {
        Button {
            print("경쟁 그만두기")
        } label: {
            HStack {
                Rectangle()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.black)
                    .cornerRadius(4)
                
                Text("경쟁 그만두기")
                    .font(.semiBold(17))
                    .foregroundColor(.black)
            }
        }
        .frame(width: 160, height: 54)
        .background(.white)
        .cornerRadius(30)
    }
}

#Preview {
    GameView()
        .environmentObject(Router())
}
