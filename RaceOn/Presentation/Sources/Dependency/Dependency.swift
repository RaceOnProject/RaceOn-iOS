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
    // Friend
    var friendUseCase: FriendUseCaseProtocol {
        get { self[FriendUseCaseKey.self] }
        set { self[FriendUseCaseKey.self] = newValue }
    }
    private enum FriendUseCaseKey: DependencyKey {
        static let liveValue: FriendUseCaseProtocol = FriendUseCase(repository: FriendRepositoryImpl())
    }
    
    // Profile
    var profileUseCase: ProfileUseCaseProtocol {
        get { self[ProfileUseCaseKey.self] }
        set { self[ProfileUseCaseKey.self] = newValue }
    }
    private enum ProfileUseCaseKey: DependencyKey {
        static let liveValue: ProfileUseCaseProtocol = ProfileUseCase(repository: ProfileRepositoryImpl())
    }
    
    // Notification
    var notificationUseCase: CheckPushStatusUseCaseProtocol {
        get { self[NotificationUseCaseKey.self] }
        set { self[NotificationUseCaseKey.self] = newValue }
    }
    private enum NotificationUseCaseKey: DependencyKey {
        static let liveValue: CheckPushStatusUseCaseProtocol = CheckPushStatusUseCase(notificationRepository: NotificationRepositoryImpl())
    }
}
