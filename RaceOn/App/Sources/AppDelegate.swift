//
//  AppDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by inforex on 2024/09/13.
//

import UIKit
import Firebase
import FirebaseMessaging
import Shared
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        requestNotificationAuthorization(application: application)
        
        Messaging.messaging().delegate = self
        
        NMFAuthManager.shared().clientId = "bkmg4kxsbs"
        
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
        UserDefaultsManager.shared.set(fcmToken, forKey: .FCMToken)
        
        print("FCM 토큰: \(fcmToken)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print("🔔 백그라운드 또는 종료 상태에서 푸시 수신: \(userInfo)")
                
        // PushNotificationData 모델로 변환 후 AppState에 저장
        if let pushData = PushNotificationData(from: userInfo) {
            AppState.shared.receivedPushData.send(pushData)
        }
        
        completionHandler(.newData)
    }
    
    // 앱이 포그라운드일 때 푸시 처리
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("🔔 앱이 포그라운드일 때 푸시 수신: \(userInfo)")
        
        // 푸시를 강제로 화면에 표시
        completionHandler([.banner, .sound, .badge])
    }
}
