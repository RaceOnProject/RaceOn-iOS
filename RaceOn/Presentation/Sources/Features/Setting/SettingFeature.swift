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
import Combine
import Shared

struct AlertInfo: Equatable, Identifiable {
    let id = UUID()
    let alert: AlertType
}

@Reducer
public struct SettingFeature {
    
    @Dependency(\.notificationUseCase) var notificationUseCase
    @Dependency(\.memberUseCase) var memberUseCase
    @Dependency(\.authUseCase) var authUseCase
    
    public init() {}
    
    public struct State: Equatable {
        var currentVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        var alertInfo: AlertInfo?
        var competitionInvites: Bool = true
        
        var hasCompletedLogoutOrDeletion: Bool = false
        
        var toast: Toast?
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case willEnterForeground
        case competitionInvitesToggled
        case logoutButtonTapped
        case deleteAccountButtonTapped
        case alertConfirmed(AlertType)
        
        case showToast(content: String)
        case dismissToast
        
        case setCompetitionInvites(Bool)
        
        case logout(response: BaseResponse<VoidResponse>)
        case setErrorMessage(String)
        
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
                return logout()
            case .deleteAccount:
                return deleteAccount()
            }
        case .showToast(let content):
            state.toast = Toast(content: content)
            return .none
        case .dismissToast:
            state.toast = nil
            return .none
        case .logout(let response):
            print(response)
            UserDefaultsManager.shared.set(false, forKey: .isAutoLogin)
            UserDefaultsManager.shared.clearAll()
            
            state.hasCompletedLogoutOrDeletion = true
            return .none
        case .setErrorMessage(let errorMessage):
            return .send(.showToast(content: errorMessage))
        case .noAction:
            return .none
        }
    }
    
    private func logout() -> Effect<Action> {
        guard let accessToken: String = UserDefaultsManager.shared.get(forKey: .accessToken),
              let refreshToken: String = UserDefaultsManager.shared.get(forKey: .refreshToken) else {
            return .send(.setErrorMessage("서버 오류입니다. 잠시후 다시 시도해주세요"))
        }
        
        return Effect.publisher {
            authUseCase.logout(accessToken: accessToken, refreshToken: refreshToken)
                .map {
                    Action.logout(response: $0)
                }
                .catch { error in
                    return Just(Action.setErrorMessage(error.message))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func deleteAccount() -> Effect<Action> {
        guard let memberId: Int = UserDefaultsManager.shared.get(forKey: .memberId) else {
            return .send(.setErrorMessage("서버 오류입니다. 잠시후 다시 시도해주세요"))
        }
        
        // TODO: 에러 처리
        return Effect.publisher {
            memberUseCase.deleteAccount(memberId: memberId)
                .map {
                    Action.logout(response: $0)
                }
                .catch { error in
                    return Just(Action.setErrorMessage(error.message))
                }
                .eraseToAnyPublisher()
        }
    }
}
