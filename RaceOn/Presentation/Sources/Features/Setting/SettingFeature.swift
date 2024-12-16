//
//  SettingFeature.swift
//  Presentation
//
//  Created by ukBook on 12/15/24.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SettingFeature {
    
    public init() {}
    
    public struct State: Equatable {
        var currentVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case noAction
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .noAction:
            return .none
        }
    }
}
