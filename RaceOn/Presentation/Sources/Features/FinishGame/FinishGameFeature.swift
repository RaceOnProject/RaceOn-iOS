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
        
        // 상대 프로필 사진, 상대 닉네임, 내 프로필 사진
        var opponentNickname: String
        var opponentProfileImageUrl: String
        var myProfileImageUrl: String
        
        // 내가 뛴 거리, 상대가 뛴 거리
        var myTotalDistance: Double
        var opponentTotalDistance: Double
        
        // 평균페이스
        var averagePace: String
        
        var userLocationArray: [NMGLatLng]
        var cameraLocation: NMGLatLng?
        
        public init(
            gameResult: GameResult? = nil,
            opponentNickname: String,
            opponentProfileImageUrl: String,
            myProfileImageUrl: String,
            myTotalDistance: Double,
            opponentTotalDistance: Double,
            averagePace: String,
            userLocationArray: [NMGLatLng]
        ) {
            self.gameResult = gameResult
            self.opponentNickname = opponentNickname
            self.opponentProfileImageUrl = opponentProfileImageUrl
            self.myProfileImageUrl = myProfileImageUrl
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
            
            // 중간 위치를 cameraLocation으로 설정
            if !state.userLocationArray.isEmpty {
                let midIndex = state.userLocationArray.count / 2
                state.cameraLocation = state.userLocationArray[midIndex]
            }
            
            return .none
        }
    }
}
