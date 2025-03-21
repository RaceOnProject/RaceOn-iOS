//
//  Router.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

// RouterCore

import ComposableArchitecture
import SwiftUI
import Domain
import NMapsMap

public enum Screen: Hashable {
    case main
    case login
    case allowAccess
    case friend
    case addFriend
    case setting
    case myProfile
    case legalNotice(type: SettingCategory)
    case matchingProcess(
        MatchingDistance,
        friendId: Int,
        isInvited: Bool,
        gameId: Int?,
        opponentNickname: String?,
        opponentProfileImageUrl: String?,
        myProfileImageUrl: String?
    )
    case game(gameId: Int?, MatchingDistance, opponentNickname: String, opponentProfileImageUrl: String, myProfileImageUrl: String)
    case finishGame(
        gameResult: GameResult,
        opponentNickname: String,
        opponentProfileImageUrl: String,
        myProfileImageUrl: String,
        myTotalDistance: Double,
        opponentTotalDistance: Double,
        averagePace: String,
        userLocationArray: [NMGLatLng]
    )
}

public final class Router: ObservableObject {
    @Published public var route: [Screen] = []
    public init() { }
    
    @MainActor
    public func push(screen: Screen) {
        route.append(screen)
    }
    
    @MainActor
    public func pop() {
        guard !route.isEmpty else { return }
        route.removeLast()
    }
    
    @MainActor
    public func pop(depth: Int) {
        guard route.count >= depth else { return }
        route.removeLast(depth)
    }
    
    @MainActor
    public func popToRoot() {
        route.removeAll()
    }
    
    @MainActor
    public func switchScreen(screen: Screen) {
        guard !route.isEmpty else { return }
        let lastIndex = route.count - 1
        route[lastIndex] = screen
    }
    
    @MainActor
    public func changeToRoot(screen: Screen) {
        route = [screen]
    }
    
    @ViewBuilder
    public func screenView(type: Screen) -> some View {
        switch type {
        case .main:
            MainView(
                store: Store(
                    initialState: MainFeature.State(),
                    reducer: { MainFeature()._printChanges() }
                )
            )
        case .login:
            LoginView(
                store: Store(
                    initialState: LoginFeature.State(),
                    reducer: { LoginFeature()._printChanges() }
                )
            )
            .environmentObject(Router())
        case .allowAccess:
            AllowAccessView(
                store: Store(
                    initialState: AllowAccessFeature.State(),
                    reducer: { AllowAccessFeature()._printChanges() }
                )
            )
        case .friend:
            FriendView(
                store: Store(
                    initialState: FriendFeature.State(),
                    reducer: { FriendFeature()._printChanges() }
                )
            )
            .environmentObject(self)
        case .addFriend:
            AddFriendView(
                store: Store(
                    initialState: AddFriendFeature.State(),
                    reducer: { AddFriendFeature()._printChanges() }
                )
            )
            .environmentObject(self)
        case .setting:
            SettingView(
                store: Store(
                    initialState: SettingFeature.State(),
                    reducer: { SettingFeature()._printChanges() }
                )
            )
            .environmentObject(self)
        case .myProfile:
            MyProfileView(
                store: Store(
                    initialState: MyProfileFeature.State(),
                    reducer: { MyProfileFeature()._printChanges() }
                )
            )
            .environmentObject(self)
        case .legalNotice(let type):
            switch type {
            case .termsOfService, .privacyPolicy:
                LegalNoticeView(
                    type: type
                )
                .environmentObject(self)
            default: Text("화면 이동 오류")
            }
        case .matchingProcess(let distance, let friendId, let isInvited, let gameId, let opponentNickname, let opponentProfileImageUrl, let myProfileImageUrl):
            MatchingProcessView(
                store: Store(
                    initialState: MatchingProcessFeature.State(
                        distance: distance,
                        friendId: friendId,
                        isInvited: isInvited,
                        gameId: gameId,
                        opponentNickname: opponentNickname,
                        opponentProfileImageUrl: opponentProfileImageUrl,
                        myProfileImageUrl: myProfileImageUrl
                    ),
                    reducer: { MatchingProcessFeature()._printChanges() }
                )
            )
            .environmentObject(self)
        case .game(let gameId, let distance, let opponentNickname, let opponentProfileImageUrl, let myProfileImageUrl):
            GameView(
                store: Store(
                    initialState: GameFeature.State(
                        gameId: gameId,
                        distance: distance,
                        opponentNickname: opponentNickname,
                        opponentProfileImageUrl: opponentProfileImageUrl,
                        myProfileImageUrl: myProfileImageUrl
                    ),
                    reducer: { GameFeature() }
                )
            ).environmentObject(self)
        case .finishGame(
            let gameResult,
            let opponentNickname,
            let opponentProfileImageUrl,
            let myProfileImageUrl,
            let myTotalDistance,
            let opponentTotalDistance,
            let averagePace,
            let userLocationArray
        ):
            FinishGameView(
                store: Store(
                    initialState: FinishGameFeature.State(
                        gameResult: gameResult,
                        opponentNickname: opponentNickname,
                        opponentProfileImageUrl: opponentProfileImageUrl,
                        myProfileImageUrl: myProfileImageUrl,
                        myTotalDistance: myTotalDistance,
                        opponentTotalDistance: opponentTotalDistance,
                        averagePace: averagePace,
                        userLocationArray: userLocationArray
                    ),
                    reducer: { FinishGameFeature()._printChanges() }
                )
            )
                .environmentObject(self)
        }
    }
}
