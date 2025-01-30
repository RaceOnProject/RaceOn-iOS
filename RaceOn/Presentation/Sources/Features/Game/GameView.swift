//
//  GameView.swift
//  Presentation
//
//  Created by ukBook on 1/19/25.
//

import Foundation
import SwiftUI
import NMapsMap
import NMapsGeometry
import ComposableArchitecture

public struct GameView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStore<GameFeature.State, GameFeature.Action>
    let store: StoreOf<GameFeature>
    
    public init(store: StoreOf<GameFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            ColorConstants.gray6.ignoresSafeArea()
            
            VStack {
                ZStack {
                    mapView
                    
                    VStack {
                        floatingView
                            .padding(.top, 20) // 상단 여백 추가
                        Spacer() // 아래로 다른 뷰를 밀어내기
                    }
                }
                
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
        .onAppear {
            viewStore.send(.onAppear)
        }
        .onDisappear {
            viewStore.send(.onDisappear)
        }
    }
    
    @ViewBuilder
    var mapView: some View {
        VStack {
            NaverMap(
                currentLocation: viewStore.state.userLoaction ?? NMGLatLng(lat: 0.0, lng: 0.0),
                userLocationArray: viewStore.state.userLocationArray
            )
        }
    }
    
    @ViewBuilder
    var floatingView: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("0.36km 앞서고 있어요!")
                        .font(.bold(24))
                        .foregroundColor(.white)
                        .padding(.top, 18)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                Spacer()
                
//                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: 152)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .init(red: 50, green: 61, blue: 22, alpha: 1),
                        .init(red: 18, green: 18, blue: 18, alpha: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(10)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    var gameDescriptionView: some View {
        HStack(spacing: 20) {
            // 남은 거리
            VStack {
                Text("남은 거리")
                    .font(.semiBold(15))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                Text(String(format: "%.2f", viewStore.state.remainingDistance) + "km")
                    .font(.bold(24))
                    .foregroundColor(.white)
                    .frame(width: 110)
            }
            
            // 평균 페이스
            VStack {
                Text("평균 페이스")
                    .font(.semiBold(15))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                Text(viewStore.state.averagePace)
                    .font(.bold(24))
                    .foregroundColor(.white)
                    .frame(width: 110)
            }
            
            // 진행 시간
            VStack {
                Text("진행 시간")
                    .font(.semiBold(15))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                Text(viewStore.state.runningTime)
                    .font(.bold(24))
                    .foregroundColor(.white)
                    .frame(width: 110)
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
    GameView(
        store: Store(
            initialState: GameFeature.State(),
            reducer: { GameFeature() }
        )
    )
        .environmentObject(Router())
}
