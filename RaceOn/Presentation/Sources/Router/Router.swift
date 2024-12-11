//
//  Router.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

// RouterCore

import ComposableArchitecture
import SwiftUI

public enum Screen: Hashable {
//    case launch
    case main
    case login
    case friend
    case addFriend
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
        route.removeLast()
    }
    
    @MainActor
    public func pop(depth: Int) {
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
}
