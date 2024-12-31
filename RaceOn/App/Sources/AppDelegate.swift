//
//  AppDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by inforex on 2024/09/13.
//

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        requestNotificationAuthorization(application: application)
        
        Messaging.messaging().delegate = self
        
        return true
    }

    /// APNs 토큰 등록 성공 시 호출
    /// - Parameters:
    ///   - application: UIApplication
    ///   - deviceToken: deviceToken
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // APNs 토큰을 Firebase에 등록
        Messaging.messaging().apnsToken = deviceToken
    }

    /// 알림 권한 요청 함수
    /// - Parameter application: UIApplication
    private func requestNotificationAuthorization(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("사용자가 알림 권한을 거부했습니다.")
            }
        }
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("FCM 토큰: \(fcmToken)")
    }
}
