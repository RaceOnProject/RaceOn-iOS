//
//  MyApp.swift
//  FriendDemoApp
//
//  Created by ukseung.dev on 9/13/24.
//

import SwiftUI
import Presentation

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            FriendLaunchView()
                .environmentObject(Router())
        }
    }
}
