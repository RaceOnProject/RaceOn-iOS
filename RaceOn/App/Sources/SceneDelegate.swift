//
//  SceneDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by inforex on 2022/10/12.
//

import UIKit
import SwiftUI

import Presentation
import ComposableArchitecture

enum RootScreen {
    case login
    case main
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // TODO: 자동 로그인 유무로 분기처리 해야함
    @State var screen: RootScreen = .login

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        #if DEBUG
            Thread.sleep(forTimeInterval: 0.5)
        #else
            Thread.sleep(forTimeInterval: 2)
        #endif
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
 
        window?.makeKeyAndVisible()
        
        let view = LoginView()
        
        let vc = UIHostingController(rootView: view)
        window?.rootViewController = vc
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    @ViewBuilder
    func customView(screen: RootScreen) -> some View {
        switch screen {
        case .login:
            LoginView(
                store: Store(
                    initialState: LoginFeature.State(),
                    reducer: { LoginFeature()._printChanges() }
                )
            )
            .environmentObject(Router())
        case .main:
            MainView().environmentObject(Router())
        }
    }
}
