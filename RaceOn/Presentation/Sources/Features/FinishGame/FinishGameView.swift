//
//  FinishGameView.swift
//  Presentation
//
//  Created by ukBook on 1/28/25.
//

import SwiftUI
import Shared
import ComposableArchitecture
import Kingfisher
import NMapsMap

public enum GameResult: Hashable, Equatable {
    case win(runningDistanceGap: Double)
    case lose(runningDistanceGap: Double)
    
    var gradientBackgroundColor: LinearGradient {
        switch self {
        case .win:
            return LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .init(red: 50, green: 61, blue: 22, alpha: 1), location: 0),
                    Gradient.Stop(color: .init(red: 18, green: 18, blue: 18, alpha: 1), location: 0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        case .lose:
            return LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .init(red: 62, green: 26, blue: 22, alpha: 1), location: 0),
                    Gradient.Stop(color: .init(red: 18, green: 18, blue: 18, alpha: 1), location: 0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var resultIcon: Image {
        switch self {
        case .win: return ImageConstants.iconWin
        case .lose: return ImageConstants.iconLose
        }
    }
    
    var title: String {
        switch self {
        case .win: return "레이스 승리!"
        case .lose: return "레이스 패배"
        }
    }
    
    var titleColor: Color {
        switch self {
        case .win: return ColorConstants.emphasis
        case .lose: return ColorConstants.primaryNormal
        }
    }
    
    var subTitle: String {
        switch self {
        case .win(let runningDistanceGap):
            return "\(runningDistanceGap.roundedToDecimal(2))km 차이로 이겼어요 💫"
        case .lose(let runningDistanceGap):
            return "\(runningDistanceGap.roundedToDecimal(2))km 차이로 졌어요 🥲"
        }
    }
}

public struct FinishGameView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStore<FinishGameFeature.State, FinishGameFeature.Action>
    let store: StoreOf<FinishGameFeature>
    
    public init(store: StoreOf<FinishGameFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            viewStore.state.gameResult.gradientBackgroundColor
                    .ignoresSafeArea()
            
            VStack {
                topView
                
                Spacer().frame(height: 24)
                
                runStatsView
                
                Spacer().frame(height: 24)
                
                mapView
                
                Spacer().frame(height: 36)
                
                raceFriendView
                
                Spacer()
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .toolbar {
            ToolbarView.leadingItems(label: ImageConstants.iconClose) {
                router.popToRoot()
            }
            
            ToolbarView.principalItem(title: "경쟁 종료")
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ColorConstants.gray6, for: .navigationBar)
    }
    
    @ViewBuilder
    var topView: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                KFImage(URL(string: viewStore.state.myProfileImageUrl))
                    .placeholder { progress in
                        ProgressView(progress)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle()) // 이미지를 동그랗게 클리핑
                
                    viewStore.state.gameResult.resultIcon
                        .frame(width: 26, height: 26)
            }
            
            VStack(alignment: .leading) {
                Text(viewStore.state.gameResult.title)
                    .foregroundColor(viewStore.state.gameResult.titleColor)
                    .font(.bold(30))
                    .padding(.bottom, 2)
                Text(viewStore.state.gameResult.subTitle)
                    .foregroundColor(ColorConstants.gray3)
                    .font(.regular(16))
            }
            .padding(.leading, 16)
            
            Spacer()
        }
        .padding(.top, 20)
        .padding(.leading, 20)
    }
    
    @ViewBuilder
    var runStatsView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("평균 페이스")
                    .font(.semiBold(15))
                    .foregroundColor(ColorConstants.gray3)
                    .padding(.bottom, 2)
                
                Text(viewStore.state.averagePace)
                    .font(.bold(24))
                    .foregroundColor(ColorConstants.gray1)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("이동 거리")
                    .font(.semiBold(15))
                    .foregroundColor(ColorConstants.gray3)
                    .padding(.bottom, 2)
                
                Text("\(viewStore.state.myTotalDistance.roundedToDecimal(2))km")
                    .font(.bold(24))
                    .foregroundColor(ColorConstants.gray1)
            }
            
            Spacer()
        }
        .padding(.leading, 20)
    }
    
    @ViewBuilder
    var mapView: some View {
        // FIXME: 실제 mapView
        GeometryReader { proxy in
            NaverMap(
                mapType: .finishGame,
                currentLocation: viewStore.state.cameraLocation ?? NMGLatLng(lat: 37.55450, lng: 126.9666),
                userLocationArray: viewStore.state.userLocationArray
            )
                .frame(width: proxy.size.width - 40, height: proxy.size.width - 40)
                .cornerRadius(24)
                .padding(.leading, 20)
                .foregroundColor(.white)
        }
        .frame(height: UIScreen.main.bounds.width - 40)
    }
    
    @ViewBuilder
    var raceFriendView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("함께 대결한 친구")
                    .font(.semiBold(15))
                    .foregroundColor(ColorConstants.gray3)
                    .padding(.bottom, 8)
                
                HStack {
                    KFImage(URL(string: viewStore.state.opponentProfileImageUrl))
                        .placeholder { progress in
                            ProgressView(progress)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle()) // 이미지를 동그랗게 클리핑
                    
                    VStack(alignment: .leading) {
                        Text("\(viewStore.state.opponentNickname)")
                            .foregroundColor(ColorConstants.gray3)
                            .font(.semiBold(17))
                            .padding(.bottom, 2)
                        Text("진행 거리 \(viewStore.state.opponentTotalDistance.roundedToDecimal(2))km")
                            .foregroundColor(ColorConstants.gray3)
                            .font(.regular(14))
                    }
                }
            }
            .padding(.leading, 20)
            
            Spacer()
        }
    }
}

#Preview {
    FinishGameView(
        store: Store(
            initialState: FinishGameFeature.State(
                gameResult: .win(runningDistanceGap: 2.0),
                opponentNickname: "조용한여우1234",
                opponentProfileImageUrl: "https://race-on.s3.ap-northeast-2.amazonaws.com/profileimage/basic_profile.png",
                myProfileImageUrl: "https://k.kakaocdn.net/dn/bf8Afk/btsDfp2vKkG/hu9Yrq95AyLMm1K9DCFqiK/img_640x640.jpg",
                myTotalDistance: 3.00,
                opponentTotalDistance: 2.55,
                averagePace: "4′35″",
                userLocationArray: [
                    NMGLatLng(lat: 37.55474, lng: 126.9704),
                    NMGLatLng(lat: 37.5547421, lng: 126.9704338),
                    NMGLatLng(lat: 37.55450, lng: 126.9666),
                    NMGLatLng(lat: 37.55290, lng: 126.9643)
                ]
            ),
            reducer: { FinishGameFeature()._printChanges() }
        )
    )
        .environmentObject(Router())
}
