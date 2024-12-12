//
//  MyApp.swift
//  SettingDemoApp
//
//  Created by inforex on 9/13/24.
//

import SwiftUI
import Presentation

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            SettingLaunchView()
                .environmentObject(Router())
        }
    }
}
