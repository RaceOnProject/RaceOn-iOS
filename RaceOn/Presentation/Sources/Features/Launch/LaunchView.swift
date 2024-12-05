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
    let store: StoreOf<LaunchFeature>
    
    init(store: StoreOf<LaunchFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(path: $router.route) {
                ZStack {
                    // TODO: 배경색 Default, #1A1A1B를 모든 화면에 적용하면 좋을 듯 함
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
                $0 ? router.changeToRoot(screen: .login) : nil
            }
        }
    }
    
    @ViewBuilder
    private func screenView(type: Screen) -> some View {
        switch type {
        case .login:
            LoginView()
                .environmentObject(Router())
        case .main:
            MainView()
                .environmentObject(Router())
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
