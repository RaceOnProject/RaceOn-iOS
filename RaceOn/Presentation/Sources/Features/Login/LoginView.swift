//
//  LoginView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import CoreLocation
import AuthenticationServices

import Shared

import ComposableArchitecture

public struct LoginView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStoreOf<LoginFeature>
    let store: StoreOf<LoginFeature>
    let appleLoginCoordinator: SignInWithAppleCoordinator
    
    public init(store: StoreOf<LoginFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
        self.appleLoginCoordinator = SignInWithAppleCoordinator(viewStore: self._viewStore)
    }
    
    public var body: some View {
        NavigationStack(path: $router.route) {
            ZStack {
                ColorConstants.gray6
                    .ignoresSafeArea()
                
                if viewStore.state.isLoginRequired {
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
                                startSignInWithAppleFlow()
                            }
                            
                        Spacer().frame(height: 34)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .toastView(
                toast: viewStore.binding(
                    get: \.toast,
                    send: .dismissToast
                )
            )
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: Screen.self) { type in
                router.screenView(type: type)
            }
            .onChange(of: viewStore.successLogin) { isSuccess in
                if isSuccess {
                    if hasLocationAccess() {
                        moveToMainView()
                    } else {
                        router.push(screen: .allowAccess)
                    }
                }
            }
        }
    }
}

public extension LoginView {
    /// window의 rootViewController MainView로 교체
    func moveToMainView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Failed to find the key window.")
            return
        }
        
        let mainView = MainView(
            store: Store(
                initialState: MainFeature.State(),
                reducer: { MainFeature()._printChanges() }
            )
        ).environmentObject(Router())
        let mainVC = UIHostingController(rootView: mainView)
        window.rootViewController = mainVC
        
        // 애니메이션 추가 (선택사항)
        UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil)
    }
    
    private func startSignInWithAppleFlow() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleLoginCoordinator
        controller.presentationContextProvider = appleLoginCoordinator
        controller.performRequests()
    }
    
    private func hasLocationAccess() -> Bool {
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
