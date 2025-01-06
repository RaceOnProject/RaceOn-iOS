//
//  SettingFeature.swift
//  Presentation
//
//  Created by ukBook on 12/15/24.
//

import Foundation
import ComposableArchitecture
import UIKit
import Domain
import Data

struct AlertInfo: Equatable, Identifiable {
    let id = UUID()
    let alert: AlertType
}

@Reducer
public struct SettingFeature {
    
    @Dependency(\.notificationUseCase) var notificationUseCase
    
    public init() {}
    
    public struct State: Equatable {
        var currentVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        var alertInfo: AlertInfo?
        var competitionInvites: Bool = true
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case willEnterForeground
        case competitionInvitesToggled
        case logoutButtonTapped
        case deleteAccountButtonTapped
        case alertConfirmed(AlertType)
        
        case setCompetitionInvites(Bool)
        
        case noAction
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                let isPushEnalbed = await notificationUseCase.execute()
                await send(.setCompetitionInvites(isPushEnalbed))
            }
        case .willEnterForeground:
            return .run { send in
                let isPushEnalbed = await notificationUseCase.execute()
                await send(.setCompetitionInvites(isPushEnalbed))
            }
        case .competitionInvitesToggled:
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return .none }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
           return .none
        case .setCompetitionInvites(let handler):
            state.competitionInvites = handler
            return .none
        case .logoutButtonTapped:
            state.alertInfo = AlertInfo(alert: .logout)
            return .none
        case .deleteAccountButtonTapped:
            state.alertInfo = AlertInfo(alert: .deleteAccount)
            return .none
        case .alertConfirmed(let alertType):
            switch alertType {
            case .logout:
                print("로그아웃 확인")
            case .deleteAccount:
                print("회원탈퇴 확인")
            }
            return .none
        case .noAction:
            return .none
        }
    }
}
