//
//  GameFeature.swift
//  Presentation
//
//  Created by ukseung.dev on 1/20/25.
//

import ComposableArchitecture
import Combine
import SwiftUICore
import CoreLocation
import NMapsMap
import NMapsGeometry

@Reducer
public struct GameFeature {
    @Dependency(\.timerService) var timerService
    @Dependency(\.locationService) var locationService
    
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        // 남은 거리, 평균 페이스, 진행 시간
        var remainingDistance: Double = 3.00
        var averagePace: String = "00′00″"
        var runningTime: String = "00:00:00"
        
        var currentLocation: NMGLatLng?
    }
    
    public enum Action {
        case onAppear
        case onDisappear
        case updateRunningTime
        case noop
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            locationService.startUpdatingLocation()
            let location = locationService.fetchCurrentLocation()
            state.currentLocation = NMGLatLng(lat: location.0, lng: location.1)
            return startTimer()
        case .onDisappear:
            return stopTimer()
        case .updateRunningTime:
            updateRunningTime(state: &state)
            return .none
        case .noop:
            return .none
        }
    }
    
    private func stopTimer() -> Effect<Action> {
        return .none
    }

    private func startTimer() -> Effect<Action> {
        return Effect.publisher {
            Timer.publish(every: 0.01, on: .main, in: .common)
                .autoconnect()
                .map { _ in Action.updateRunningTime }
                .eraseToAnyPublisher()
        }
    }
    
    private func updateRunningTime(state: inout State) {
        var currentTime = state.runningTime.split(separator: ":").map { Int($0) ?? 0 }
        currentTime[2] += 1
        if currentTime[2] >= 100 {
            currentTime[2] = 0
            currentTime[1] += 1
            if currentTime[1] >= 60 {
                currentTime[1] = 0
                currentTime[0] += 1
            }
        }
        state.runningTime = String(format: "%02d:%02d:%02d", currentTime[0], currentTime[1], currentTime[2])
    }
}
