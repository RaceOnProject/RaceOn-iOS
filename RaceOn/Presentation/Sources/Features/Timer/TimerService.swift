//
//  TimerService.swift
//  Presentation
//
//  Created by ukBook on 1/19/25.
//

import Foundation
import Combine
import ComposableArchitecture

struct TimerService: DependencyKey {
    var start: () -> Void
    var stop: () -> Void
    var reset: () -> Void
    var currentTimePublisher: () -> AnyPublisher<Void, Never>
    
    static let liveValue = Self.live()
    
    static func live() -> Self {
        let currentTimeSubject = CurrentValueSubject<Void, Never>(())
        var timer: AnyCancellable?
        
        return Self(
            start: {
                timer?.cancel()
                timer = Timer.publish(every: 30.0, on: .main, in: .common)
                    .autoconnect()
                    .sink(receiveValue: { _ in currentTimeSubject.send(()) })
            },
            stop: {
                timer?.cancel()
                timer = nil
            },
            reset: {
                timer?.cancel()
                currentTimeSubject.send(())
            },
            currentTimePublisher: { currentTimeSubject.eraseToAnyPublisher() }
        )
    }
}
