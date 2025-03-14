//
//  NaverMapView.swift
//  Presentation
//
//  Created by ukseung.dev on 1/20/25.
//

import UIKit
import SwiftUI
import NMapsMap
import Dependencies

// TODO: 백그라운드에서도 refresh
// TODO: 위치 권한
// TODO: 현위치에서 카메라 시작 [v]
// TODO: 움직일때 카메라가 따라오기 [v]
// TODO: 경로 표시 [v]
// TODO: 남은거리 [v]
// TODO: 평균 페이스
// TODO: 진행 시간 [v]
// TODO: 경쟁 그만두기

enum NaverMapType {
    case game
    case finishGame
    
    var isScrollGestureEnabled: Bool {
        switch self {
        case .game: return false
        case .finishGame: return true
        }
    }
    
    var zoomLevel: Double {
        switch self {
        case .game: return 17
        case .finishGame: return 12
        }
    }
    
    var showLocationButton: Bool {
        switch self {
        case .game: return false
        case .finishGame: return true
        }
    }
    
    var showZoomControls: Bool {
        switch self {
        case .game: return false
        case .finishGame: return true
        }
    }
    
    var showCompass: Bool {
        switch self {
        case .game: return false
        case .finishGame: return true
        }
    }
    
    var showScaleBar: Bool {
        switch self {
        case .game: return false
        case .finishGame: return true
        }
    }
}

struct NaverMap: UIViewRepresentable {
    
    var mapType: NaverMapType
    var currentLocation: NMGLatLng
    var userLocationArray: [NMGLatLng]
    
    init(mapType: NaverMapType, currentLocation: NMGLatLng, userLocationArray: [NMGLatLng]) {
        self.mapType = mapType
        self.currentLocation = currentLocation
        self.userLocationArray = userLocationArray
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(mapType: mapType)
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
//         카메라 이동
//        print("currentLocation => \(currentLocation)")
        let cameraUpdate = NMFCameraUpdate(scrollTo: currentLocation)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
        
        let pathOverlay = NMFPath()
        pathOverlay.path = NMGLineString(points: userLocationArray)
        pathOverlay.width = 5
        pathOverlay.color = .systemBlue
        pathOverlay.outlineWidth = 0
        pathOverlay.mapView = uiView.mapView // 지도에 오버레이 연결
        
        let marker = NMFMarker()
        marker.position = userLocationArray.isEmpty ? NMGLatLng(lat: 0, lng: 0) : userLocationArray[0]
        marker.mapView = uiView.mapView
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = .systemBlue
        marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
//        print("userLocationArray => \(userLocationArray)")
    }
}

final class Coordinator: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    @Dependency(\.locationService) var locationService
//    static let shared = Coordinator()
    
    // Coordinator 클래스 안의 코드
    // 클래스 상단에 변수 설정을 해줘야 한다.
    let view = NMFNaverMapView(frame: .zero)
    var mapType: NaverMapType
    
    // Coordinator 클래스 안의 코드
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {} // 카메라 이동이 시작되기 전 호출되는 함수
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {} // 카메라의 위치가 변경되면 호출되는 함수
    
    init(mapType: NaverMapType) {
        self.mapType = mapType
        super.init()
        
        let zoomLevel = mapType.zoomLevel
        let isScrollGestureEnabled = mapType.isScrollGestureEnabled
        let showLocationButton = mapType.showLocationButton
        let showZoomControls = mapType.showZoomControls
        let showCompass = mapType.showCompass
        let showScaleBar = mapType.showScaleBar
        
        view.mapView.positionMode = .compass
        view.mapView.isNightModeEnabled = true
        view.mapView.zoomLevel = zoomLevel
        view.mapView.maxZoomLevel = 19
        view.mapView.isScrollGestureEnabled = isScrollGestureEnabled
        view.showLocationButton = showLocationButton
        view.showZoomControls = showZoomControls
        view.showCompass = showCompass
        view.showScaleBar = showScaleBar
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
        
        let location = locationService.fetchCurrentLocation()
        let nMGLatLng = NMGLatLng(lat: location.0, lng: location.1)
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: nMGLatLng, zoomTo: 17)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        
        view.mapView.moveCamera(cameraUpdate)
    }
    
    // Coordinator 클래스 안의 코드
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    // Coordinator 클래스 안의 코드
//    func fetchUserLocation() {
////        if let locationManager = locationManager {
////            let lat = locationManager.location?.coordinate.latitude
////            let lng = locationManager.location?.coordinate.longitude
//            let cameraUpdate = NMFCameraUpdate(scrollTo: userLocation, zoomTo: 17)
//            cameraUpdate.animation = .easeIn
//            cameraUpdate.animationDuration = 1
//            
//            let locationOverlay = view.mapView.locationOverlay
//            locationOverlay.location = userLocation
//            locationOverlay.hidden = false
//            
//            let pathOverlay = NMFPath()
//            pathOverlay.path = NMGLineString(points: [
//                NMGLatLng(lat: 37.47652, lng: 126.9645),
//                NMGLatLng(lat: 37.4765190, lng: 126.9644737),
//                NMGLatLng(lat: 37.47598, lng: 126.9643),
//                NMGLatLng(lat: 37.47542, lng: 126.9656)
//            ])
//            pathOverlay.width = 6
//            pathOverlay.color = .systemBlue
//            pathOverlay.outlineWidth = 0
////            pathOverlay.passedColor = .blue
////            pathOverlay.passedOutlineColor = .green
//            pathOverlay.mapView = view.mapView // 지도에 오버레이 연결
//            
//            view.mapView.moveCamera(cameraUpdate)
////        }
//    }
}
