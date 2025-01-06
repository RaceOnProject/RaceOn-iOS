//
//  LoginView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import CoreLocation

import Shared

import ComposableArchitecture

public enum SocialLogin {
    case kakao
    case apple
}

public struct LoginView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStoreOf<LoginFeature>
    let store: StoreOf<LoginFeature>
    
    public init(store: StoreOf<LoginFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        NavigationStack(path: $router.route) {
            ZStack {
                ColorConstants.gray6
                    .ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    ImageConstants.loginLogo
                        .resizable()
                        .aspectRatio(220/85, contentMode: .fit)
                        .padding(.horizontal, 85)
                    
                    Spacer()
                    
                    ImageConstants.loginCenter
                        .resizable()
                        .aspectRatio(300/224, contentMode: .fit)
                        .padding(.horizontal, 45)
                    
                    Spacer().frame(height: 90)
                    
                    ImageConstants.kakaoLogin
                        .resizable()
                        .frame(width: 350, height: 54)
                        .onTapGesture {
                            viewStore.send(.kakaoLoginButtonTapped)
                        }
                    
                    Spacer().frame(height: 12)
                    
                    ImageConstants.appleLogin
                        .resizable()
                        .frame(width: 350, height: 54)
                        .onTapGesture {
                            if hasLocationAccess() {
                                router.changeToRoot(screen: .main)
                            } else {
                                router.push(screen: .allowAccess)
                            }
                        }
                        
                    Spacer().frame(height: 34)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: Screen.self) { type in
                router.screenView(type: type)
            }
        }
    }
}

public extension LoginView {
    func hasLocationAccess() -> Bool {
        let locationManager = CLLocationManager()
        let authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: return true
        case .denied, .restricted, .notDetermined: return false
        default: return false
        }
    }
}

#Preview {
    LoginView(
        store: Store(
            initialState: LoginFeature.State(),
            reducer: { LoginFeature()._printChanges() }
        )
    )
    .environmentObject(Router())
}
