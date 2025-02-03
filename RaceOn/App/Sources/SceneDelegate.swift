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
import KakaoSDKCommon
import KakaoSDKAuth

import Shared

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
            Thread.sleep(forTimeInterval: 0.1)
        #else
            Thread.sleep(forTimeInterval: 1)
        #endif
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
 
        window?.makeKeyAndVisible()
        
        let view = customView(screen: screen)
        
        let vc = UIHostingController(rootView: view)
        window?.rootViewController = vc
        
        KakaoSDK.initSDK(appKey: "8d7586b19e44d18f82eb280b3e57bae1")
        
        // 🔔 푸시로 앱이 실행된 경우 !
        guard let notificationResponse = connectionOptions.notificationResponse else { return }
        let userInfo = notificationResponse.notification.request.content.userInfo
        
        // PushNotificationData 모델로 변환 후 AppState에 저장
        if let pushData = PushNotificationData(from: userInfo) {
            AppState.shared.receivedPushData.send(pushData)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
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
            MainView(
                store: Store(
                    initialState: MainFeature.State(),
                    reducer: { MainFeature()._printChanges() }
                )
            ).environmentObject(Router())
        }
    }
}
