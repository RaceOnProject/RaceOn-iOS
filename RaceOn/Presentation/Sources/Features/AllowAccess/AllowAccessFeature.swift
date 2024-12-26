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
        var isRequested: Bool = false
    }
    
    public enum Action: Equatable {
        case confirmButtonTapped
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .confirmButtonTapped:
            state.isRequested = true
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
