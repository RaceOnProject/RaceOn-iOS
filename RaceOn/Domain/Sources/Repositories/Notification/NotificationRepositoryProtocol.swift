//
//  NotificationRepositoryProtocol.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

import UserNotifications

public protocol NotificationRepositoryProtocol {
    func getPushStatus() async -> UNAuthorizationStatus
}
