//
//  FinishGameFeature.swift
//  Presentation
//
//  Created by ukBook on 2/8/25.
//

import Foundation
import ComposableArchitecture
import Combine

@Reducer
final public class FinishGameFeature {
    public init() {}
    public struct State: Equatable {
        public init() {}
        
        var gameResult: GameResult = .lose(runningDistanceGap: 2.0)
        
        // 평균페이스, 이동거리
        var averagePace: String = "00′00″"
        var distanceMoved: String = "3"
    }
    
    public enum Action {
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    }
}
