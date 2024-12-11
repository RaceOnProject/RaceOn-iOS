//
//  LaunchScreen.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import Shared
import ComposableArchitecture

public struct LaunchView: View {
    enum Constants {
        static let splashLogo = PresentationAsset.splashLogo.swiftUIImage
    }
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStore<LaunchFeature.State, LaunchFeature.Action>
    let store: StoreOf<LaunchFeature>
    
    
    public init(store: StoreOf<LaunchFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        NavigationStack(path: $router.route) {
            ZStack {
                // TODO: Default 배경색을 모든 화면에 적용하면 좋을 듯 함
                CommonConstants.defaultBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    Constants.splashLogo
                        .resizable()
                        .frame(width: 220, height: 148.14)
                }
            }
            .navigationDestination(for: Screen.self) { type in
                screenView(type: type)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .onChange(of: viewStore.shouldNavigate) {
            // TODO: 기존에 로그인 유무에 따라 Main 화면으로 이동할지 Login 화면으로 이동할지 분기처리
//            $0 ? router.changeToRoot(screen: .login) : nil
            $0 ? router.push(screen: .friend) : nil
        }
    }
    
    @ViewBuilder
    private func screenView(type: Screen) -> some View {
        switch type {
        case .login:
            LoginView()
                .environmentObject(router)
        case .main:
            MainView()
                .environmentObject(router)
        case .friend:
            FriendView(
                store: Store(
                    initialState: FriendFeature.State(),
                    reducer: { FriendFeature()._printChanges() }
                )
            )
            .environmentObject(router)
        case .addFriend:
            AddFriendView(
                store: Store(
                    initialState: AddFriendFeature.State(),
                    reducer: { AddFriendFeature()._printChanges() }
                )
            )
            .environmentObject(router)
        }
    }
}

#Preview {
    LaunchView(
        store: Store(
            initialState: LaunchFeature.State(),
            reducer: { LaunchFeature()._printChanges() }
        )
    )
    .environmentObject(Router())
}
