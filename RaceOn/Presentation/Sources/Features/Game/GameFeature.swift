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
    @Dependency(\.webSocketClient) var webSocketClient
    
    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        // 남은 거리, 평균 페이스, 진행 시간
        var remainingDistance: Double = 3.00
        var averagePace: String = "00′00″"
        var runningTime: String = "00:00:00"

        // 총 뛴 거리
        var totalDistanceMoved: Double = 0.0
        
        // 총 뛴 시간(초)
        var elapsedTimeInSeconds: Int = 0
        
        var userLoaction: NMGLatLng?
        var userLocationArray: [NMGLatLng] = []
    }
    
    public enum Action {
        case onAppear
        case onDisappear
        case updateRunningTime
        case updateLocation((Double, Double))
        case updateAveragePace(String)
        case updateDistance(Double)
        case sendMessage(String)
        case receivedMessage(String) // 메시지 수신 액션
        case noop
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            locationService.startUpdatingLocation()
            return subscribeToRunningUpdates()
        case .onDisappear:
            locationService.stopUpdatingLocation()
            webSocketClient.disconnect()
            return stopTimer()
        case .updateLocation(let location):
            state.userLoaction = NMGLatLng(lat: location.0, lng: location.1)
            state.userLocationArray.append(NMGLatLng(lat: location.0, lng: location.1))
            
            if state.userLocationArray.count > 3 {
                state.userLocationArray.removeFirst()
            }
            return .none
        case .updateAveragePace(let averagePace):
            print("!평균 페이스 \(averagePace)")
            state.averagePace = averagePace
            return .none
        case .updateRunningTime:
            updateRunningTime(state: &state)
            return .none
        case .updateDistance(let distance):
            state.totalDistanceMoved += distance
            state.remainingDistance -= distance
            state.averagePace = formatPace(timeInSeconds: state.elapsedTimeInSeconds, distanceInKilometers: state.totalDistanceMoved)
            
            print("뛴 거리 \(distance) km")
            print("총 뛴거리 \(state.totalDistanceMoved) km")
            print("남은 거리 \(state.remainingDistance)")
            print("총 뛴 시간(초) \(state.elapsedTimeInSeconds)")
            print("평균 페이스 \(state.averagePace)")
            
            return .none
        case .sendMessage(let message):
            webSocketClient.sendMessage(message)
            return .none
        case .receivedMessage(let message):
            return .none
        case .noop:
            return .none
        }
    }
    
    /// 평균 페이스 계산기
    /// - Parameters:
    ///   - timeInSeconds: 시간(초)
    ///   - distanceInKilometers: 뛴 총 거리
    /// - Returns: ex) "8′00″"
    func formatPace(timeInSeconds: Int, distanceInKilometers: Double) -> String {
        guard distanceInKilometers > 0 else { return "거리 정보가 유효하지 않습니다." }
        
        let paceInSeconds = Double(timeInSeconds) / distanceInKilometers
        let minutes = Int(paceInSeconds) / 60
        let seconds = Int(paceInSeconds) % 60
        
        return String(format: "%d′%02d″", minutes, seconds)
    }
    
    private func stopTimer() -> Effect<Action> {
        return .none
    }

    private func updateRunningTime(state: inout State) {
        var currentTime = state.runningTime.split(separator: ":").map { Int($0) ?? 0 }
        currentTime[2] += 1 // 초 증가
        
        if currentTime[2] >= 60 {
            currentTime[2] = 0
            currentTime[1] += 1 // 분 증가
            
            if currentTime[1] >= 60 {
                currentTime[1] = 0
                currentTime[0] += 1 // 시 증가
            }
        }
        
        // 뛴 초를 계산
        state.elapsedTimeInSeconds = currentTime[0] * 3600 + currentTime[1] * 60 + currentTime[2]
        
        // DisplayTime
        state.runningTime = String(format: "%02d:%02d:%02d", currentTime[0], currentTime[1], currentTime[2])
    }
    
    private func subscribeToRunningUpdates() -> Effect<Action> {
        return Effect.merge(
            Effect.publisher {
                Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                    .map { _ in Action.updateRunningTime }
                    .eraseToAnyPublisher()
            },
            Effect.publisher {
                locationService.currentLocationPublisher()
                    .removeDuplicates { previous, current in
                        // 위도와 경도 모두 동일한 경우 중복 제거
                        previous.0 == current.0 && previous.1 == current.1
                    }
                    .map {
//                        print("위도, 경도 \($0.0), \($0.1)")
                        return Action.updateLocation(($0.0, $0.1))
                    }
            },
            Effect.publisher {
                locationService.averagePacePublisher()
                    .map {
                        print("평균 페이스 \($0)")
                        return Action.updateAveragePace($0)
                    }
            },
            Effect.publisher {
                locationService.distanceMovedPublisher()
                    .map {
                        return Action.updateDistance($0)
                    }
            }
        )
    }
}
