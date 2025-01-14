//
//  AllowAccessFeature.swift
//  Presentation
//
//  Created by inforex on 12/26/24.
//

import SwiftUI
import Foundation
import CoreLocation

import ComposableArchitecture

@Reducer
public struct AllowAccessFeature {
    public init () {}
    
    public struct State: Equatable {
        public init () {}
    }
    
    public enum Action: Equatable {
        case requestAuthorization
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .requestAuthorization:
            return requestAuthorization()
        }
    }
}

public extension AllowAccessFeature {
    func requestAuthorization() -> Effect<Action> {
        return .run { _ in
            let locationManager = CLLocationManager()
            
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
