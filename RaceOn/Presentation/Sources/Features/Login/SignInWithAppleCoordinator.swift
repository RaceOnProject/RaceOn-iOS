//
//  LoginAppleRepresentableView.swift
//  Presentation
//
//  Created by inforex on 1/8/25.
//

import SwiftUI
import AuthenticationServices
import ComposableArchitecture
import Foundation

// MARK: - APPLE LOGIN
class SignInWithAppleCoordinator: NSObject,
                                  ASAuthorizationControllerDelegate,
                                  ASAuthorizationControllerPresentationContextProviding {
    
    @ObservedObject var viewStore: ViewStoreOf<LoginFeature>
    
    init(viewStore: ObservedObject<ViewStoreOf<LoginFeature>>) {
        self._viewStore = viewStore
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let tokenData = appleIDCredential.identityToken,
                  let token = String(data: tokenData, encoding: .utf8)
            else {
                return
            }
            
            viewStore.send(.requestLogin(token, .apple))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIWindow()
    }
}
