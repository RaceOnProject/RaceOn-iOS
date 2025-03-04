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
import Kingfisher

public enum MatchStatus: Equatable {
    case win(distance: Double)
    case lose(distance: Double)
    
    var backgroundColor: LinearGradient {
        switch self {
        case .win:
            return LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .init(red: 50, green: 61, blue: 22, alpha: 1), location: 0),
                    Gradient.Stop(color: .init(red: 18, green: 18, blue: 18, alpha: 1), location: 0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        case .lose:
            return LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .init(red: 62, green: 26, blue: 22, alpha: 1), location: 0),
                    Gradient.Stop(color: .init(red: 18, green: 18, blue: 18, alpha: 1), location: 0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var title: String {
        switch self {
        case .win(let distance):
            return "\(distance.roundedToDecimal(2))km 앞서고 있어요!"
        case .lose(let distance):
            return "\(distance.roundedToDecimal(2))km 뒤처지고 있어요.."
        }
    }
    
    var profileIcon: Image {
        switch self {
        case .win: return ImageConstants.iconMeWin
        case .lose: return ImageConstants.iconMeLose
        }
    }
    
    var barColor: Color {
        switch self {
        case .win:
            return ColorConstants.emphasis
        case .lose:
            return ColorConstants.primaryNormal
        }
    }
}

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
                        .ignoresSafeArea()
                    
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
        .gesture(
            DragGesture().onEnded { _ in
                router.popToRoot()
            }
        )
        .onChange(of: viewStore.state.isReadyForNextScreen) { handler in
            guard let gameResult = viewStore.state.gameResult else { return }
            
            viewStore.send(.setReadyForNextScreen(false))
            
            if handler {
                router.push(screen:
                    .finishGame(
                        gameResult: gameResult,
                        opponentNickname: viewStore.state.opponentNickname,
                        opponentProfileImageUrl: viewStore.state.opponentProfileImageUrl,
                        myProfileImageUrl: viewStore.state.myProfileImageUrl,
                        myTotalDistance: viewStore.state.myTotalDistance,
                        opponentTotalDistance: viewStore.state.opponentTotalDistance,
                        averagePace: viewStore.state.averagePace,
                        userLocationArray: viewStore.state.userLocationArray
                    )
                )
            }
        }
        .toastView(
            toast: viewStore.binding(
                get: \.toast,
                send: .dismissToast
            )
        )
        .customAlert(
            isPresented: viewStore.isPresentedCustomAlert,
            alertType: .stop(nickname: viewStore.state.opponentNickname),
            presentAction: {
                viewStore.send(.handleCustomAlert(handler: true))
            },
            dismissAction: {
                viewStore.send(.handleCustomAlert(handler: false))
            }
        )
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    var mapView: some View {
        VStack {
            NaverMap(
                mapType: .game,
                currentLocation: viewStore.state.userLoaction ?? NMGLatLng(lat: 0.0, lng: 0.0),
                userLocationArray: viewStore.state.userLocationArray
            )
        }
    }
    
    @ViewBuilder
    var floatingView: some View {
        if !(viewStore.state.myTotalDistance == viewStore.state.opponentTotalDistance) {
            GeometryReader { proxy in
                let totalWidth = proxy.size.width - 80 // 진행바의 width
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewStore.state.matchStatus.title)
                            .font(.bold(24))
                            .foregroundColor(.white)
                            .padding(.top, 18)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        ZStack(alignment: .leading) {
                            ZStack(alignment: .top) { // 상대 아이콘
                                ImageConstants.iconOpponent
                                    .frame(width: 40, height: 48)
                                
                                KFImage(URL(string: viewStore.state.opponentProfileImageUrl))
                                    .resizable()
                                    .frame(width: 34, height: 34)
                                    .clipShape(Circle())
                                    .padding(.top, 3)
                            }
                            .padding(.leading, totalWidth * (viewStore.state.opponentTotalDistance / viewStore.state.totalDistance))
                            
                            ZStack(alignment: .top) { // 나의 아이콘
                                viewStore.state.matchStatus.profileIcon
                                    .frame(width: 40, height: 48)
                                
                                KFImage(URL(string: viewStore.state.myProfileImageUrl))
                                    .resizable()
                                    .frame(width: 34, height: 34)
                                    .clipShape(Circle())
                                    .padding(.top, 3)
                            }
                            .zIndex(0)
                            .padding(.leading, totalWidth * (viewStore.state.myTotalDistance / viewStore.state.totalDistance))
                    }
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 6)
                                .foregroundColor(ColorConstants.gray5)
                                .cornerRadius(30)
                                .padding(.bottom, 20)
                                .padding(.horizontal, 20)
                            
                            Rectangle()
                                .frame(height: 6)
                                .foregroundColor(viewStore.state.matchStatus.barColor)
                                .cornerRadius(30)
                                .padding(.bottom, 20)
                                .padding(.horizontal, 20)
                                .padding(.leading, totalWidth * (viewStore.leadingLocation ?? 0.0))
                                .padding(.trailing, totalWidth * (viewStore.trailingLocation ?? 0.0))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 152)
                    .background(viewStore.state.matchStatus.backgroundColor)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
        }
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
            viewStore.send(.stopCompetition)
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
            initialState: GameFeature.State(
                gameId: 1,
                distance: .three,
                opponentNickname: "조용한여우1234",
                opponentProfileImageUrl: "https://k.kakaocdn.net/dn/bf8Afk/btsDfp2vKkG/hu9Yrq95AyLMm1K9DCFqiK/img_640x640.jpg",
                myProfileImageUrl: "https://race-on.s3.ap-northeast-2.amazonaws.com/profileimage/basic_profile.png"
            ),
            reducer: { GameFeature() }
        )
    )
        .environmentObject(Router())
}
