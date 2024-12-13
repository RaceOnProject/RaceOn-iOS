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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
 
        window?.makeKeyAndVisible()
        
        let view = LaunchView(
            store: Store(
                initialState: LaunchFeature.State(),
                reducer: { LaunchFeature()._printChanges() }
            )
        )
        .environmentObject(Router())
        
        let vc = UIHostingController(rootView: view)
        
//        let vc = UIViewController()
//        vc.view.backgroundColor = .blue
        
        window?.rootViewController = vc
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
