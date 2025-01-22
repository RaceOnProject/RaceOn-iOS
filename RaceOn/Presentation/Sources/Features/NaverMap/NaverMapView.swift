//
//  NaverMapView.swift
//  Presentation
//
//  Created by ukseung.dev on 1/20/25.
//

import UIKit
import SwiftUI
import NMapsMap

// TODO: 백그라운드에서도 refresh
// TODO: 위치 권한
// TODO: 현위치에서 카메라 시작 [v]
// TODO: 움직일때 카메라가 따라오기
// TODO: 경로 표시
// TODO: 남은거리
// TODO: 평균 페이스
// TODO: 진행 시간 [v]
// TODO: 경쟁 그만두기

struct NaverMap: UIViewRepresentable {
    
    var userLocation: NMGLatLng
    
    func makeCoordinator() -> Coordinator {
        Coordinator(userLocation: userLocation)
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
}

final class Coordinator: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
//    static let shared = Coordinator()
    
    // Coordinator 클래스 안의 코드
    // 클래스 상단에 변수 설정을 해줘야 한다.
    var userLocation: NMGLatLng
//    @Published var coord: (Double, Double) = (0.0, 0.0)
//    @Published var userLocation: (Double, Double) = (0.0, 0.0)
    
//    var locationManager: CLLocationManager?
    
    let view = NMFNaverMapView(frame: .zero)
    
    // Coordinator 클래스 안의 코드
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {} // 카메라 이동이 시작되기 전 호출되는 함수
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {} // 카메라의 위치가 변경되면 호출되는 함수
    
    init(userLocation: NMGLatLng) {
        self.userLocation = userLocation
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        view.mapView.zoomLevel = 17
        view.mapView.maxZoomLevel = 19
        view.showLocationButton = false
        view.showZoomControls = false
        view.showCompass = false
        view.showScaleBar = false
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: userLocation, zoomTo: 17)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        
        view.mapView.moveCamera(cameraUpdate)
    }
    
    // Coordinator 클래스 안의 코드
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    // MARK: - 위치 정보 동의 확인
//    func checkLocationAuthorization() {
//        guard let locationManager = locationManager else { return }
//        
//        switch locationManager.authorizationStatus {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted:
//            print("위치 정보 접근이 제한되었습니다.")
//        case .denied:
//            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
//        case .authorizedAlways, .authorizedWhenInUse:
//            print("Success")
//            locationManager.startUpdatingLocation()
//            
////            coord = (
////                Double(locationManager.location?.coordinate.latitude ?? 0.0),
////                Double(locationManager.location?.coordinate.longitude ?? 0.0)
////            )
////            userLocation = (
////                Double(locationManager.location?.coordinate.latitude ?? 0.0),
////                Double(locationManager.location?.coordinate.longitude ?? 0.0)
////            )
//            
//            fetchUserLocation()
//            
//        @unknown default:
//            break
//        }
//    }
    
//    func checkIfLocationServiceIsEnabled() {
//        DispatchQueue.global().async {
//            if CLLocationManager.locationServicesEnabled() {
//                DispatchQueue.main.async {
//                    self.locationManager = CLLocationManager()
//                    self.locationManager!.delegate = self
//                    self.checkLocationAuthorization()
//                }
//            } else {
//                print("Show an alert letting them know this is off and to go turn i on")
//            }
//        }
//    }
    
    // Coordinator 클래스 안의 코드
    func fetchUserLocation() {
//        if let locationManager = locationManager {
//            let lat = locationManager.location?.coordinate.latitude
//            let lng = locationManager.location?.coordinate.longitude
            let cameraUpdate = NMFCameraUpdate(scrollTo: userLocation, zoomTo: 17)
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 1
            
            let locationOverlay = view.mapView.locationOverlay
            locationOverlay.location = userLocation
            locationOverlay.hidden = false
            
            let pathOverlay = NMFPath()
            pathOverlay.path = NMGLineString(points: [
                NMGLatLng(lat: 37.47652, lng: 126.9645),
                NMGLatLng(lat: 37.4765190, lng: 126.9644737),
                NMGLatLng(lat: 37.47598, lng: 126.9643),
                NMGLatLng(lat: 37.47542, lng: 126.9656)
            ])
            pathOverlay.width = 6
            pathOverlay.color = .systemBlue
            pathOverlay.outlineWidth = 0
//            pathOverlay.passedColor = .blue
//            pathOverlay.passedOutlineColor = .green
            pathOverlay.mapView = view.mapView // 지도에 오버레이 연결
            
            view.mapView.moveCamera(cameraUpdate)
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("🔥 \(locations)")
    }
}
