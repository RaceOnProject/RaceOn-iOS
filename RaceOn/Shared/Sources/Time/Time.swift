//
//  Time.swift
//  Shared
//
//  Created by ukBook on 1/5/25.
//

import Foundation

public func timeAgo(from isoDateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 시간 파싱의 일관성을 위해 설정
    
    guard let date = dateFormatter.date(from: isoDateString) else {
        return "알 수 없음"
    }
    
    let now = Date()
    let diff = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)
    
    if let year = diff.year, year > 0 {
        return "\(year)년 전 접속"
    }
    
    if let month = diff.month, month > 0 {
        return "\(month)달 전 접속"
    }
    
    if let day = diff.day, day > 0 {
        return "\(day)일 전 접속"
    }
    
    if let hour = diff.hour, hour > 0 {
        return "\(hour)시간 전 접속"
    }
    
    if let minute = diff.minute, minute > 0 {
        return "\(minute)분 전 접속"
    }
    
    return "방금 전"
}
