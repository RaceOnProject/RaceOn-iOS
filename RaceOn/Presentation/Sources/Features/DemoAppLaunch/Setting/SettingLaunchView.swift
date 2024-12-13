//
//  SettingLaunchView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/12/24.
//

import SwiftUI
import ComposableArchitecture

public struct SettingLaunchView: View {
    public init() {}
    
    @EnvironmentObject var router: Router
    
    public var body: some View {
        Text("Setting Demo App")
    }
}

#Preview {
    SettingLaunchView()
        .environmentObject(Router())
}

