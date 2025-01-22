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
    
    // 현재 위치를 저장하는 프로퍼티
    public var currentLocation = PassthroughSubject<(Double, Double), Never>()
    
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
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("🤖 \(location.coordinate.latitude)")
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
}
