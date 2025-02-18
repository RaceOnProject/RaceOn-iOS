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
import NMapsMap

@main
struct MyApp: App {
    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.route) {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    VStack {
                        Button {
                            //                        router.push(screen: .matchingProcess(<#T##MatchingDistance#>, friendId: <#T##Int#>, isInvited: <#T##Bool#>, gameId: <#T##Int?#>))
                        } label: {
                            Text("대기 화면으로")
                                .foregroundColor(.white)
                                .padding(100)
                        }
                        .background(.blue)
                        
                        Button {
                            //                        router.push(screen: .game(gameId: 1, .three))
                        } label: {
                            Text(("지도 화면으로"))
                                .foregroundColor(.white)
                                .padding(100)
                        }
                        .background(.blue)
                        
                        Button {
                            print("경쟁 완료 화면으로")
                            router.push(screen:
                                    .finishGame(
                                        gameResult: .win(runningDistanceGap: 2.0),
                                        opponentNickname: "조용한여우1234",
                                        opponentProfileImageUrl: "https://race-on.s3.ap-northeast-2.amazonaws.com/profileimage/basic_profile.png",
                                        myProfileImageUrl: "https://k.kakaocdn.net/dn/bf8Afk/btsDfp2vKkG/hu9Yrq95AyLMm1K9DCFqiK/img_640x640.jpg",
                                        myTotalDistance: 3.00,
                                        opponentTotalDistance: 2.55,
                                        averagePace: "4′35″",
                                        userLocationArray: [
                                            NMGLatLng(lat: 37.55474, lng: 126.9704),
                                            NMGLatLng(lat: 37.5547421, lng: 126.9704338),
                                            NMGLatLng(lat: 37.55450, lng: 126.9666),
                                            NMGLatLng(lat: 37.55290, lng: 126.9643)
                                        ]
                                    )
                            )
                        } label: {
                            Text(("경쟁 완료 화면으로"))
                                .foregroundColor(.white)
                                .padding(100)
                        }
                        .background(.blue)
                    }
                }
                .navigationDestination(for: Screen.self) { type in
                    router.screenView(type: type)
                }
            }
        }
    }
}
