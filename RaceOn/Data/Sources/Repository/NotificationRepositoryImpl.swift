//
//  NotificationRepositoryImpl.swift
//  Data
//
//  Created by ukseung.dev on 1/2/25.
//

import Domain
import UserNotifications

public final class NotificationRepositoryImpl: NotificationRepositoryProtocol {
    public init() {}
    
    public func getPushStatus() async -> UNAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
    }
}
