//
//  FinishGameFeature.swift
//  Presentation
//
//  Created by ukBook on 2/8/25.
//

import Foundation
import ComposableArchitecture
import Combine
import NMapsMap

@Reducer
final public class FinishGameFeature {
    public init() {}
    public struct State: Equatable {
        var gameResult: GameResult?
        
        // 내 프로필 사진, 상대 프로필 사진, 상대 닉네임
        var myProfileURL: String
        var opponentURL: String
        var opponentNickname: String
        
        // 내가 뛴 거리, 상대가 뛴 거리
        var myTotalDistance: Double
        var opponentTotalDistance: Double
        
        // 평균페이스
        var averagePace: String
        
        var userLocationArray: [NMGLatLng]
        var cameraLocation: NMGLatLng?
        
        public init(
            gameResult: GameResult? = nil,
            myProfileURL: String,
            opponentURL: String,
            opponentNickname: String,
            myTotalDistance: Double,
            opponentTotalDistance: Double,
            averagePace: String,
            userLocationArray: [NMGLatLng]
        ) {
            self.gameResult = gameResult
            self.myProfileURL = myProfileURL
            self.opponentURL = opponentURL
            self.opponentNickname = opponentNickname
            self.myTotalDistance = myTotalDistance
            self.opponentTotalDistance = opponentTotalDistance
            self.averagePace = averagePace
            self.userLocationArray = userLocationArray
        }
    }
    
    public enum Action {
        case onAppear
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            if state.myTotalDistance > state.opponentTotalDistance {
                state.gameResult = .win(runningDistanceGap: state.myTotalDistance - state.opponentTotalDistance)
            } else {
                state.gameResult = .lose(runningDistanceGap: state.opponentTotalDistance - state.myTotalDistance)
            }
            return .none
        }
    }
}
