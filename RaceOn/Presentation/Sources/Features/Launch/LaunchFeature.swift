//
//  LaunchFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import Foundation
import ComposableArchitecture

public struct LaunchFeature: Reducer {
    public init() {}
    
    public struct State: Equatable {
        var shouldNavigate: Bool = false
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case onAppear
        case navigateTriggered
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                #if DEBUG
                    try await Task.sleep(nanoseconds: 500_000_000)
                #else
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                #endif
                await send(.navigateTriggered)
            }
            
        case .navigateTriggered:
            state.shouldNavigate = true
            return .none
        }
    }
}

