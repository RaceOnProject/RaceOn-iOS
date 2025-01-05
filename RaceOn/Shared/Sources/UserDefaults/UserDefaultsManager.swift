//
//  UserDefaultsManager.swift
//  Shared
//
//  Created by ukseung.dev on 1/2/25.
//

import Foundation

// UserDefaults에 저장되는 키를 정의하는 열거형
public enum UserDefaultsKey: String {
    // Auth
    case FCMToken
    case accessToken
    case refreshToken
}

// UserDefaults를 관리하는 클래스
public final class UserDefaultsManager {
    
    public static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    // 값을 저장하는 제네릭 메서드
    public func set<T>(_ value: T?, forKey key: UserDefaultsKey) {
        if let value = value as? String {
            userDefaults.set(value, forKey: key.rawValue)
        } else if let value = value as? Bool {
            userDefaults.set(value, forKey: key.rawValue)
        } else if let value = value as? Int {
            userDefaults.set(value, forKey: key.rawValue)
        } else if let value = value as? Double {
            userDefaults.set(value, forKey: key.rawValue)
        } else if let value = value as? Data {
            userDefaults.set(value, forKey: key.rawValue)
        }
    }
    
    // 값을 가져오는 제네릭 메서드
    public func get<T>(forKey key: UserDefaultsKey) -> T? {
        return userDefaults.value(forKey: key.rawValue) as? T
    }
    
    // 값 삭제 메서드
    public func remove(forKey key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    // 모든 UserDefaults 값 삭제
    public func clearAll() {
        for key in UserDefaultsKey.allCases {
            remove(forKey: key)
        }
    }
}

extension UserDefaultsKey: CaseIterable {
    // UserDefaultsKey 열거형의 모든 값을 가져오는 메서드 추가
    public static var allCases: [UserDefaultsKey] {
        return [.FCMToken]
    }
}
