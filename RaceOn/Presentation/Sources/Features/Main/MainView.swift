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
}

public struct MainView: View {

    @EnvironmentObject var router: Router
    let store: StoreOf<MainFeature>
    @ObservedObject var viewStore: ViewStoreOf<MainFeature>
    //TODO: Feature로 이동 예정
    @State var selectedMatchingDistance: MatchingDistance = .three
    @State private var isThrottling = false
    
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
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isShowSheet,
                    send: .dismissSheet
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
            switch selectedMatchingDistance {
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
            TabView(selection: $selectedMatchingDistance) {
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
            
            HStack {
                if selectedMatchingDistance != .three {
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
                
                if selectedMatchingDistance != .ten {
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
        withAnimation(.easeOut(duration: 0.2)) {
            switch selectedMatchingDistance {
            case .five:
                selectedMatchingDistance = .three
                print("3")
            case .ten:
                selectedMatchingDistance = .five
                print("5")
            default:
                return
            }
        }
    }
    
    /// 탭뷰 오른쪽 버튼 탭
    private func rightTabButtonTapped() {
        withAnimation(.easeOut(duration: 0.2)) {
            switch selectedMatchingDistance {
            case .three:
                selectedMatchingDistance = .five
                print("5")
            case .five:
                selectedMatchingDistance = .ten
                print("10")
            default:
                return
            }
        }
    }
}
