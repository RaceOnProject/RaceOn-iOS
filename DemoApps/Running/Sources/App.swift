//
//  MyApp.swift
//  FriendDemoApp
//
//  Created by inforex on 9/13/24.
//

import SwiftUI
import Presentation
import ComposableArchitecture
import Domain

@main
struct MyApp: App {
    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.route) {
                VStack {
                    Button {
//                        router.push(screen: .matchingProcess(.three, Friend()))
                    } label: {
                        Text("대기 화면으로")
                            .foregroundColor(.white)
                            .padding(100)
                    }
                    .background(.blue)
                    
                    Button {
                        router.push(screen: .game(gameId: 1, .three))
                    } label: {
                        Text(("지도 화면으로"))
                            .foregroundColor(.white)
                            .padding(100)
                    }
                    .background(.blue)
                    
                    Button {
                        print("경쟁 완료 화면으로")
//                        router.push(screen: .finishGame)
                    } label: {
                        Text(("경쟁 완료 화면으로"))
                            .foregroundColor(.white)
                            .padding(100)
                    }
                    .background(.blue)
                }
                    .navigationDestination(for: Screen.self) { type in
                        router.screenView(type: type)
                    }
            }
        }
    }
}
