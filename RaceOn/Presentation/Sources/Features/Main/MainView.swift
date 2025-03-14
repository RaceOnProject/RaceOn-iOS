//
//  MainView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import Combine
import Shared
import ComposableArchitecture

public enum MatchingDistance {
    case three
    case five
    case ten
    
    var distance: Double {
        switch self {
        case .three: return 3.0
        case .five: return 5.0
        case .ten: return 10.0
        }
    }
    
    var distanceFormat: Double {
        switch self {
        case .three: return 3.00
        case .five: return 5.00
        case .ten: return 10.00
        }
    }
    
    var timeLimit: Int {
        switch self {
        case .three: return 30
        case .five: return 60
        case .ten: return 90
        }
    }
}

public struct MainView: View {

    @EnvironmentObject var router: Router
    let store: StoreOf<MainFeature>
    @ObservedObject var viewStore: ViewStoreOf<MainFeature>
    @State private var isThrottling = false
    @ObservedObject var appState = AppState.shared
    
    public init(store: StoreOf<MainFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        NavigationStack(path: $router.route) {
            ZStack {
                ColorConstants.gray6.ignoresSafeArea()
                
                gradation
                
                VStack(spacing: 0) {
                    topBar
                    
                    title
                    
                    distanceTabView
                    
                    startButton
                    
                    Spacer().frame(height: 76)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: Screen.self) { type in
                router.screenView(type: type)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
            .onChange(of: viewStore.state.isReadyForNextScreen) {
                guard let friendId = viewStore.state.friendId else {
                    return
                }
                let distance = viewStore.state.selectedMatchingDistance
                let isInvited = viewStore.state.isInvited
                let gameId = viewStore.state.gameId
                
                let opponentNickname = viewStore.state.opponentNickname
                let opponentProfileImageUrl = viewStore.state.opponentProfileImageUrl
                let myProfileImageUrl = viewStore.state.myProfileImageUrl
                
                viewStore.send(.setIsReadForNextScreen)
                $0 ? router.push(screen:
                        .matchingProcess(
                            distance,
                            friendId: friendId,
                            isInvited: isInvited,
                            gameId: gameId,
                            opponentNickname: opponentNickname,
                            opponentProfileImageUrl: opponentProfileImageUrl,
                            myProfileImageUrl: myProfileImageUrl
                        )
                ) : nil
            }
            .onReceive(AppState.shared.receivedPushData) { newValue in
                if let newValue = newValue {
                    print("푸시 데이터 업데이트: \(newValue)")
                    viewStore.send(.receivePushNotificationData(newValue))
                }
            }
            .customAlert(
                isPresented: viewStore.isPresentedCustomAlert,
                alertType: .invite(nickname: "\(viewStore.pushNotificationData?.requestNickname ?? "")"),
                presentAction: {
                    viewStore.send(.presentCustomAlert)
                },
                dismissAction: {
                    viewStore.send(.dismissCustomAlert)
                }
            )
            .toastView(
                toast: viewStore.binding(
                    get: \.toast,
                    send: .dismissToast
                )
            )
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isShowSheet,
                    send: { .isPresentedSheet($0) }
                )
            ) {
                ModalFriendView(
                    store: Store(
                        initialState: ModalFriendFeature.State(),
                        reducer: { ModalFriendFeature()._printChanges() }
                    ),
                    selectedFriend: viewStore.binding(
                        get: \.selectedCompetitionFreind,
                        send: { .selectedCompetitionFreind($0) }
                    )
                )
                    .presentationDetents([
                        .medium
                    ])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    @ViewBuilder
    var gradation: some View {
        GeometryReader { proxy in
            switch viewStore.state.selectedMatchingDistance {
            case .three:
                RadialGradient(
                    stops: [.init(color: Color(red: 223, green: 84, blue: 56), location: 0.0),
                            .init(color: Color(red: 223, green: 84, blue: 56, alpha: 0), location: 1.0)],
                    center: .bottom,
                    startRadius: 0,
                    endRadius: proxy.size.height / 2 )
                .opacity(0.3)
                .ignoresSafeArea()
            case .five:
                RadialGradient(
                    stops: [.init(color: Color(red: 223, green: 84, blue: 56), location: 0.0),
                            .init(color: Color(red: 122, green: 83, blue: 252), location: 0.6),
                            .init(color: ColorConstants.gray6, location: 1.0)],
                    center: .bottom,
                    startRadius: 0,
                    endRadius: proxy.size.height * 0.7)
                .opacity(0.3)
                .ignoresSafeArea()
            case .ten:
                RadialGradient(
                    stops: [.init(color: Color(red: 223, green: 84, blue: 56), location: 0.0),
                            .init(color: Color(red: 122, green: 83, blue: 252), location: 0.5),
                            .init(color: ColorConstants.gray6, location: 1.0)],
                    center: .bottom,
                    startRadius: 0,
                    endRadius: proxy.size.height )
                .opacity(0.3)
                .ignoresSafeArea()
            }
        }
    }
    
    @ViewBuilder
    var topBar: some View {
        ZStack {
            HStack {
                ImageConstants.graphicLogo
                    .resizable()
                    .frame(width: 90, height: 20.53)
                
                Spacer()
                
                HStack(spacing: 20) {
                    ImageConstants.iconFriends
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            router.push(screen: .friend)
                        }
                    
                    ImageConstants.iconSetting
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            router.push(screen: .setting)
                        }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 54)
    }
    
    @ViewBuilder
    var title: some View {
        HStack {
            Text("거리를 설정하고\n경쟁을 시작해보세요!")
                .foregroundStyle(.white)
                .font(.bold(24))
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    var distanceTabView: some View {
        
        ZStack {
            TabView(selection: viewStore.binding(
                get: \.selectedMatchingDistance,
                send: { .matchingDistanceSelected($0) }
            )) {
                ImageConstants.card3km
                    .resizable()
                    .cornerRadius(24)
                    .aspectRatio(280/400, contentMode: .fit)
                    .padding(.horizontal, 55)
                    .tag(MatchingDistance.three)
                    
                ImageConstants.card5km
                    .resizable()
                    .cornerRadius(24)
                    .aspectRatio(280/400, contentMode: .fit)
                    .padding(.horizontal, 55)
                    .tag(MatchingDistance.five)
                
                ImageConstants.card10km
                    .resizable()
                    .cornerRadius(24)
                    .aspectRatio(280/400, contentMode: .fit)
                    .padding(.horizontal, 55)
                    .tag(MatchingDistance.ten)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeOut(duration: 0.2))
            
            HStack {
                if viewStore.state.selectedMatchingDistance != .three {
                    ImageConstants.iconChevronLeft
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            if !isThrottling {
                                isThrottling = true
                                leftTabButtonTapped()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isThrottling = false
                                }
                            }
                        }
                }
                
                Spacer()
                
                if viewStore.state.selectedMatchingDistance != .ten {
                    ImageConstants.iconChevronRight
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            if !isThrottling {
                                isThrottling = true
                                rightTabButtonTapped()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isThrottling = false
                                }
                            }
                        }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 50)
    }
    
    @ViewBuilder
    var startButton: some View {
        Button {
            viewStore.send(.startButtonTapped)
        } label: {
            Text("경쟁할 친구 선택하기")
                .font(.semiBold(17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 54)
        .background(ColorConstants.primaryNormal)
        .cornerRadius(30)
        .padding(.top, 30)
        .padding(.horizontal, 55)
    }
}

private extension MainView {
    /// 탭뷰 왼쪽 버튼 탭
    private func leftTabButtonTapped() {
        switch viewStore.state.selectedMatchingDistance {
        case .five:
            viewStore.send(.matchingDistanceSelected(.three))
        case .ten:
            viewStore.send(.matchingDistanceSelected(.five))
        default:
            return
        }
    }
    
    /// 탭뷰 오른쪽 버튼 탭
    private func rightTabButtonTapped() {
        switch viewStore.state.selectedMatchingDistance {
        case .three:
            viewStore.send(.matchingDistanceSelected(.five))
        case .five:
            viewStore.send(.matchingDistanceSelected(.ten))
        default:
            return
        }
    }
}
