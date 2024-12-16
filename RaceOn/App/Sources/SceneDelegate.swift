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
    @State var screen: RootScreen = .main

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        print(#function)
        
        #if DEBUG
            Thread.sleep(forTimeInterval: 0.5)
        #else
            Thread.sleep(forTimeInterval: 2)
        #endif
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
 
        window?.makeKeyAndVisible()
        
        let view = customView(screen: screen)
        
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
            LoginView().environmentObject(Router())
        case .main:
            MainView().environmentObject(Router())
        }
    }
}
