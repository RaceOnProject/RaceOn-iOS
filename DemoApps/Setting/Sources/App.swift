//
//  MyApp.swift
//  SettingDemoApp
//
//  Created by inforex on 9/13/24.
//

import SwiftUI
import Presentation
import ComposableArchitecture

@main
struct MyApp: App {
    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.route) {
                Text("Setting Demo App Root View")
                    .navigationDestination(for: Screen.self) { type in
                        router.screenView(type: type)
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    router.push(screen: .setting)
                }
            }
        }
    }
}
