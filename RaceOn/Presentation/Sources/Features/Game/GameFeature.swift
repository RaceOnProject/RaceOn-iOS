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
import Data
import Shared
import Domain

@Reducer
public struct GameFeature {
    @Dependency(\.timerService) var timerService
    @Dependency(\.locationService) var locationService
    @Dependency(\.webSocketClient) var webSocketClient
    
    public init() {}
    
    public struct State: Equatable {
        var matchStatus: MatchStatus = .win(distance: 0.4)
        var gameId: Int?
        // 남은 거리, 평균 페이스, 진행 시간
        var totalDistance: Double
        var remainingDistance: Double
        var averagePace: String = "00′00″"
        var runningTime: String = "00:00:00"

        // 내가 총 뛴 거리, 상대가 총 뛴 거리
        var myTotalDistance: Double = 0.0
        var opponentTotalDistance: Double = 0.0
        
        var leadingLocation: Double?
        var trailingLocation: Double?
        
        // 총 뛴 시간(초)
        var elapsedTimeInSeconds: Int = 0
        
        var userLoaction: NMGLatLng?
        var userLocationArray: [NMGLatLng] = []
        
        var userLatitude: Double?
        var userLongitude: Double?
        
        // 상대 닉네임, 상대 프로필 이미지, 내 프로필 이미지
        var opponentNickname: String
        var opponentProfileImageUrl: String
        var myProfileImageUrl: String
        
        var isPresentedCustomAlert: Bool = false
        var isReadyForNextScreen: Bool = false
        
        // 게임 결과
        var gameResult: GameResult?
        
        var toast: Toast?
        
        var reqeustMemberId: Int?
        
        public init(gameId: Int?, distance: MatchingDistance, opponentNickname: String, opponentProfileImageUrl: String, myProfileImageUrl: String) {
            self.gameId = gameId
            self.totalDistance = distance.distanceFormat
            self.remainingDistance = distance.distanceFormat
            
            self.opponentNickname = opponentNickname
            self.opponentProfileImageUrl = opponentProfileImageUrl
            self.myProfileImageUrl = myProfileImageUrl
        }
    }
    
    public enum Action {
        case onAppear
        case onDisappear
        case updateRunningTime
        case updateLocation((Double, Double))
        case updateAveragePace(String)
        case updateDistance(Double)
        case updateOpponentDistance(ProcessResponse)
        case updateMyDistance(ProcessResponse)
        case setReadyForNextScreen(Bool)
        case updateTrackingData
        case receiveMessage(String)
        case setWebSocketStatus(WebSocketStatus)
        case stopCompetition
        case handleCustomAlert(handler: Bool)
        case dismissToast
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            locationService.startUpdatingLocation()
            return .merge(
                subscribeToRunningUpdates(),
                webSocketUpdatesPublisher(),
                startTrackingDataTimer(),
                .run { _ in timerService.stop() }
            )
        case .onDisappear:
            locationService.stopUpdatingLocation()
            return .merge(
                stopTimer(),
                stopWebSocketUpdates(),
                stopTrackingTimer(),
                .run { _ in timerService.start() }
            )
        case .updateLocation(let location):
            state.userLatitude = location.0
            state.userLongitude = location.1
            state.userLoaction = NMGLatLng(lat: location.0, lng: location.1)
            state.userLocationArray.append(NMGLatLng(lat: location.0, lng: location.1))
            
            return .none
        case .updateAveragePace(let averagePace):
            print("!평균 페이스 \(averagePace)")
            state.averagePace = averagePace
            return .none
        case .updateRunningTime:
            updateRunningTime(state: &state)
            return .none
        case .updateDistance(let distance):
            state.myTotalDistance += distance
            state.remainingDistance -= distance
            state.averagePace = formatPace(timeInSeconds: state.elapsedTimeInSeconds, distanceInKilometers: state.myTotalDistance)
            
//            print("뛴 거리 \(distance) km")
//            print("총 뛴거리 \(state.myTotalDistance) km")
//            print("남은 거리 \(state.remainingDistance)")
//            print("총 뛴 시간(초) \(state.elapsedTimeInSeconds)")
//            print("평균 페이스 \(state.averagePace)")
            
            if state.myTotalDistance > state.opponentTotalDistance {
                state.matchStatus = .win(distance: state.myTotalDistance - state.opponentTotalDistance)
                
                state.leadingLocation = state.opponentTotalDistance / state.totalDistance
                state.trailingLocation = 1.00 - state.myTotalDistance / state.totalDistance
            } else {
                state.matchStatus = .lose(distance: state.opponentTotalDistance - state.myTotalDistance)
                state.leadingLocation = state.myTotalDistance / state.totalDistance
                state.trailingLocation = 1.00 - state.opponentTotalDistance / state.totalDistance
            }
            return .none
        case .updateOpponentDistance(let response):
            state.opponentTotalDistance = response.distance
            
            if state.myTotalDistance > state.opponentTotalDistance {
                state.matchStatus = .win(distance: state.myTotalDistance - state.opponentTotalDistance)
                
                state.leadingLocation = state.opponentTotalDistance / state.totalDistance
                state.trailingLocation = 1.00 - state.myTotalDistance / state.totalDistance
            } else {
                state.matchStatus = .lose(distance: state.opponentTotalDistance - state.myTotalDistance)
                state.leadingLocation = state.myTotalDistance / state.totalDistance
                state.trailingLocation = 1.00 - state.opponentTotalDistance / state.totalDistance
            }
            
            return response.isFinished ? .send(.setReadyForNextScreen(true)) : .none
        case .updateMyDistance(let response):
            return response.isFinished ? .send(.setReadyForNextScreen(true)) : .none
        case .setReadyForNextScreen(let handler):
            if state.myTotalDistance > state.opponentTotalDistance {
                state.gameResult = .win(runningDistanceGap: state.myTotalDistance - state.opponentTotalDistance)
            } else {
                state.gameResult = .lose(runningDistanceGap: state.opponentTotalDistance - state.myTotalDistance)
            }
            state.isReadyForNextScreen = handler
            return .none
        case .updateTrackingData:
            guard let gameId = state.gameId,
                  let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId),
                  let latitude = state.userLatitude,
                  let longitude = state.userLongitude else { return .none }
            
            let time = state.runningTime
            let distance = state.myTotalDistance
            
            return .run { _ in
                webSocketClient.sendWebSocketMessage(
                    .process(
                        gameId: gameId,
                        memberId: memberId,
                        time: time,
                        latitude: latitude,
                        longitude: longitude,
                        distance: distance,
                        avgSpeed: 0.0,
                        maxSpeed: 0.0
                    )
                )
            }
        case .receiveMessage(let message):
            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { return .none }
            
            traceLog(message)
            
            if let jsonData = message.data(using: .utf8) {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
//                    traceLog("📌 JSON 데이터: \(jsonObject ?? [:])")
                    
                    if let type = jsonObject?["command"] as? String {
                        switch type {
                        case "PROCESS":
                            let decodedData = try JSONDecoder().decode(ProcessData.self, from: jsonData)
                            if decodedData.data.memberId != memberId {
                                traceLog("🏃🏻 상대방이 뛴 정보 \(decodedData)")
                                return .send(.updateOpponentDistance(decodedData.data))
                            } else {
                                traceLog("🔥 내가 뛴 정보 \(decodedData)")
                                return .send(.updateMyDistance(decodedData.data))
                            }
                        case "STOP":
                            traceLog("📌 JSON 데이터: \(jsonObject ?? [:])")
                            guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { return .none }
                            let decodedData = try JSONDecoder().decode(StopData.self, from: jsonData)
                            
                            let requestMemberId = decodedData.data.requestMemberId
                            let curMemberId = decodedData.data.curMemberId
                            let isInProgress = decodedData.data.isInProgress
                            let isAgree = decodedData.data.isAgree
                            
                            if requestMemberId == curMemberId && requestMemberId != memberId { // 중단 요청 알림
                                if isInProgress && !isAgree {
                                    state.isPresentedCustomAlert = true
                                    state.reqeustMemberId = decodedData.data.requestMemberId
                                }
                            } else if requestMemberId != curMemberId {
                                if !isInProgress && isAgree { // 중단 승락
                                    return .send(.setReadyForNextScreen(true))
                                } else {
                                    state.toast = Toast(content: "게임 중단이 거절되었습니다.")
                                }
                            }
                        default:
                            print("⚠️ 예상하지 못한 타입: \(type)")
                        }
                    } else {
                        print("⚠️ 'command' 필드 없음, 기본 처리 수행")
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                }
            }
            return .none
        case .setWebSocketStatus(let status):
            traceLog("🏆 웹 소켓 Status \(status)")
            return .none
        case .stopCompetition:
            guard let gameId = state.gameId,
                  let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else { return .none }
            
            state.toast = Toast(content: "경쟁 종료를 요청했습니다.")
            
            webSocketClient.sendWebSocketMessage(
                .stop(
                    gameId: gameId,
                    memberId: memberId,
                    requestMemberId: memberId,
                    handler: true
                )
            )
            return .none
        case .handleCustomAlert(let handler):
            guard let gameId = state.gameId,
                  let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId),
                  let reqeustMemberId = state.reqeustMemberId else { return .none }
            state.isPresentedCustomAlert = false
            
            return .run { _ in
                webSocketClient.sendWebSocketMessage(
                    .stop(
                        gameId: gameId,
                        memberId: memberId,
                        requestMemberId: reqeustMemberId,
                        handler: handler
                    )
                )
            }
        case .dismissToast:
            state.toast = nil
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
    
    private func webSocketUpdatesPublisher() -> Effect<Action> {
        return Effect.merge(
            Effect.publisher {
                webSocketClient.messagePublisher()
                    .map {
//                        print("🏆 MessagePublisher Action 생성: \($0)")
                        return Action.receiveMessage($0)
                    }
            },
            Effect.publisher {
                webSocketClient.statusPublisher()
                    .map {
                        print("🏆 StatusPublisher Action 생성: \($0)") // Action 생성 확인
                        return Action.setWebSocketStatus($0)
                    }
            }
        )
        .cancellable(id: "GameWebSocketUpdatesPublisher", cancelInFlight: true)
    }
    
    private func stopWebSocketUpdates() -> Effect<Action> {
        return .cancel(id: "GameWebSocketUpdatesPublisher")
    }
    
    private func startTrackingDataTimer() -> Effect<Action> {
        return Effect
            .publisher {
                Timer.publish(every: 3, on: .main, in: .common)
                    .autoconnect()
                    .map { _ in Action.updateTrackingData }
                    .eraseToAnyPublisher()
            }
            .cancellable(id: "trackingTimer", cancelInFlight: true)
    }

    private func stopTrackingTimer() -> Effect<Action> {
        return .cancel(id: "trackingTimer")
    }
}
