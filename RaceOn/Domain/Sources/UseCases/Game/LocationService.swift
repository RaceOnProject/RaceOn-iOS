//
//  LocationService.swift
//  Domain
//
//  Created by ukseung.dev on 1/22/25.
//

import Foundation
import CoreLocation
import Combine

public final class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var previousLocation: CLLocation?
    private var totalDistance: Double = 0 // 움직인 거리 저장
    
    // 현재 위치를 저장하는 프로퍼티
    public var currentLocation = PassthroughSubject<(Double, Double), Never>()
    
    // 평균 페이스
    public var averagePace = PassthroughSubject<String, Never>()
    
    // 뛴 거리
    public var distanceMoved = PassthroughSubject<Double, Never>()
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // 10미터 단위로 업데이트
    }
    
    public func startUpdatingLocation() {
        // 위치 권한 요청
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.stopUpdatingLocation()
        }
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        previousLocation = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.currentLocation.send((currentLocation.coordinate.latitude, currentLocation.coordinate.longitude))
        
        if let previousLocation = previousLocation {
            // 두 좌표 간 거리 계산 (미터 단위)
            let distance = currentLocation.distance(from: previousLocation)
            print("이동 거리: \(Double(distance) / 1000) km")
            
            distanceMoved.send(Double(distance) / 1000)
        }
        
        // 현재 위치를 저장
        previousLocation = currentLocation
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error)")
    }
    
    public func fetchCurrentLocation() -> (Double, Double) {
        let lat = self.locationManager.location?.coordinate.latitude ?? 0
        let lng = self.locationManager.location?.coordinate.longitude ?? 0

        return (lat, lng)
    }
    
    public func currentLocationPublisher() -> AnyPublisher<(Double, Double), Never> {
        return currentLocation.eraseToAnyPublisher()
    }
    
    public func averagePacePublisher() -> AnyPublisher<String, Never> {
        return averagePace.eraseToAnyPublisher()
    }
    
    public func distanceMovedPublisher() -> AnyPublisher<Double, Never> {
        return distanceMoved.eraseToAnyPublisher()
    }
}
