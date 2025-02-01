//
//  AppState.swift
//  Shared
//
//  Created by ukBook on 2/1/25.
//

import Combine
import Foundation

import Foundation

public struct PushNotificationData: Equatable {
    public let title: String
    public let message: String
    public let command: String?
    public let timeLimit: String?
    public let distance: String?
    public let gameId: String?
    public let requestNickname: String?
    public let receivedNickname: String?
    public let requestMemberId: String?
    public let receivedMemberId: String?

    public init?(from userInfo: [AnyHashable: Any]) {
        guard let aps = userInfo["aps"] as? [String: Any],
              let alert = aps["alert"] as? [String: Any],
              let title = alert["title"] as? String,
              let message = alert["body"] as? String else {
            return nil
        }
        
        self.title = title
        self.message = message
        self.command = userInfo["command"] as? String
        self.timeLimit = userInfo["timeLimit"] as? String
        self.distance = userInfo["distance"] as? String
        self.gameId = userInfo["gameId"] as? String
        self.requestNickname = userInfo["requestNickname"] as? String
        self.receivedNickname = userInfo["receivedNickname"] as? String
        self.requestMemberId = userInfo["requestMemberId"] as? String
        self.receivedMemberId = userInfo["receivedMemberId"] as? String
    }
}

public final class AppState: ObservableObject {
    public static let shared = AppState()
    
    public let receivedPushData = CurrentValueSubject<PushNotificationData?, Never>(nil)
}
