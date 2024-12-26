//
//  LoginFeature.swift
//  Presentation
//
//  Created by inforex on 12/26/24.
//

import SwiftUI
import Foundation
import CoreLocation

import ComposableArchitecture

@Reducer
public struct LoginFeature {
    public init () {}
    
    public struct State: Equatable {
        public init () {}
    }
    
    public enum Action: Equatable {
        case testAction
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        default: return .none
        }
    }
}
