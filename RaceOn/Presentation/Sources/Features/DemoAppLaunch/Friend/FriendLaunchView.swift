//
//  FriendLaunchView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/12/24.
//

import SwiftUI
import ComposableArchitecture

public struct FriendLaunchView: View {
    public init() {}
    
    @EnvironmentObject var router: Router
    
    public var body: some View {
        NavigationStack(path: $router.route) {
            Text("Freind Demo App")
                .navigationDestination(for: Screen.self) { type in
                    router.screenView(type: type)
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                router.changeToRoot(screen: .friend)
            }
        }
    }
}

#Preview {
    FriendLaunchView()
        .environmentObject(Router())
}
