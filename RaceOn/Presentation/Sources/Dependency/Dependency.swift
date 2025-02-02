//
//  Dependency.swift
//  Presentation
//
//  Created by ukseung.dev on 1/6/25.
//

import Domain
import Data
import Dependencies

extension DependencyValues {
    
    // Auth
    var authUseCase: AuthUseCaseProtocol {
        get { self[AuthUseCaseKey.self] }
        set { self[AuthUseCaseKey.self] = newValue }
    }
    private enum AuthUseCaseKey: DependencyKey {
        static let liveValue: AuthUseCaseProtocol = AuthUseCase(repository: AuthRepositoryImpl())
    }
    
    // Friend
    var friendUseCase: FriendUseCaseProtocol {
        get { self[FriendUseCaseKey.self] }
        set { self[FriendUseCaseKey.self] = newValue }
    }
    private enum FriendUseCaseKey: DependencyKey {
        static let liveValue: FriendUseCaseProtocol = FriendUseCase(repository: FriendRepositoryImpl())
    }
    
    // Game
    var gameUseCase: GameUseCaseProtocol {
        get { self[GameUseCaseKey.self] }
        set { self[GameUseCaseKey.self] = newValue }
    }
    private enum GameUseCaseKey: DependencyKey {
        static let liveValue: GameUseCaseProtocol = GameUseCase(repository: GameRepositoryImpl())
    }
    
    // Profile
    var memberUseCase: MemberUseCaseProtocol {
        get { self[ProfileUseCaseKey.self] }
        set { self[ProfileUseCaseKey.self] = newValue }
    }
    private enum ProfileUseCaseKey: DependencyKey {
        static let liveValue: MemberUseCaseProtocol = MemberUseCase(repository: MemberRepositoryImpl())
    }
    
    // Notification
    var notificationUseCase: CheckPushStatusUseCaseProtocol {
        get { self[NotificationUseCaseKey.self] }
        set { self[NotificationUseCaseKey.self] = newValue }
    }
    
    private enum NotificationUseCaseKey: DependencyKey {
        static let liveValue: CheckPushStatusUseCaseProtocol = CheckPushStatusUseCase(notificationRepository: NotificationRepositoryImpl())
    }
    
    // Timer
    var timerService: TimerService {
        get { self[TimerService.self] }
        set { self[TimerService.self] = newValue }
    }
    
    // Location
    var locationService: LocationService {
        get { self[LocationServiceKey.self] }
        set { self[LocationServiceKey.self] = newValue }
    }
    
    private enum LocationServiceKey: DependencyKey {
        static let liveValue = LocationService()
        static let previewValue = LocationService()
    }
    
    // WebSocket
    var webSocketClient: WebSocketManager {
        get { self[WebSocketClientKey.self] }
        set { self[WebSocketClientKey.self] = newValue }
    }
    
    private enum WebSocketClientKey: DependencyKey {
        static let liveValue = WebSocketManager.shared
    }
}
