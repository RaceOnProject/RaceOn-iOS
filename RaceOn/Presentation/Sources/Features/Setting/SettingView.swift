//
//  SettingView.swift
//  Presentation
//
//  Created by ukBook on 12/15/24.
//

import SwiftUI
import ComposableArchitecture

public enum SettingCategory: CaseIterable {
    case myProfile            // 내 프로필
    case competitionInvites   // 경쟁 초대 알림
    case appInfo              // 앱 정보
    case termsOfService       // 이용약관
    case privacyPolicy        // 개인정보처리방침
    
    var title: String {
        switch self {
        case .myProfile: return "내 프로필"
        case .competitionInvites: return "경쟁 초대 알림"
        case .appInfo: return "앱 정보"
        case .termsOfService: return "이용약관"
        case .privacyPolicy: return "개인정보처리방침"
        }
    }
    
    var urlString: String {
        switch self {
        case .termsOfService: return "https://heewonp.notion.site/7eef2b58c96b4256b27cd54ab4333851?pvs=4"
        case .privacyPolicy: return "https://heewonp.notion.site/f67621a3ee514a8580373f51a8e3aba1?pvs=4"
        default: return ""
        }
    }
}

public enum AlertType {
    case logout
    case deleteAccount
    
    var title: Text {
        switch self {
        case .logout: return Text("로그아웃")
        case .deleteAccount: return Text("회원탈퇴")
        }
    }
    
    var message: Text {
        switch self {
        case .logout: return Text("'RACE ON'에서 로그아웃 하시겠습니까?")
        case .deleteAccount: return Text("정말 계정을 삭제하시겠습니까?")
        }
    }
    
    var cancelButton: Alert.Button {
        return .cancel(Text("취소"))
    }
    
    func defaultButton(action: @escaping () -> Void) -> Alert.Button {
        return .default(Text("확인"), action: action)
    }
}

public struct SettingView: View {
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStore<SettingFeature.State, SettingFeature.Action>
    let store: StoreOf<SettingFeature>
    
    var settings: [SettingCategory] = SettingCategory.allCases
    
    public init(store: StoreOf<SettingFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            ColorConstants.gray6
                .ignoresSafeArea()
            
            VStack {
                List(settings, id: \.self) { settings in
                    Button(action: {
                        switch settings {
                        case .myProfile:
                            router.push(screen: .myProfile)
                        case .termsOfService, .privacyPolicy:
                            router.push(screen: .legalNotice(type: settings))
                        default: break
                        }
                    }, label: {
                        SettingContentView(
                            type: settings,
                            competitionInvites: viewStore.binding(
                                get: \.competitionInvites,
                                send: .competitionInvitesToggled
                            ),
                            appVersion: viewStore.binding(
                                get: \.currentVersion,
                                send: .noAction
                            )
                        )
                    })
                    .listRowSeparator(.hidden)
                    .listRowBackground(ColorConstants.gray6)
                    .listRowInsets(EdgeInsets())
                    .frame(height: 56)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden) // 기본 배경색 숨기기
                .background(ColorConstants.gray6)
                .scrollDisabled(true)
                .padding(.top, 12)
                
                HStack(alignment: .center) {
                    Button(action: {
                        viewStore.send(.logoutButtonTapped)
                    }, label: {
                        HStack {
                            Text("로그아웃")
                                .font(.semiBold(14))
                                .foregroundColor(.white)
                                .padding(10)
                        }
                    })
                    
                    ImageConstants.dividingLine
                    
                    Button(action: {
                        viewStore.send(.deleteAccountButtonTapped)
                    }, label: {
                        HStack {
                            Text("회원탈퇴")
                                .font(.semiBold(14))
                                .foregroundColor(.white)
                                .padding(10)
                        }
                    })
                }
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewStore.send(.willEnterForeground)
        }
        .alert(item: viewStore.binding(
            get: \.alertInfo,
            send: .noAction
        )) { alertInfo in
            Alert(
                title: alertInfo.alert.title,
                message: alertInfo.alert.message,
                primaryButton: alertInfo.alert.defaultButton {
                    viewStore.send(.alertConfirmed(alertInfo.alert))
                },
                secondaryButton: alertInfo.alert.cancelButton
            )
        }
        .toolbar {
            ToolbarView.leadingItems {
                router.pop()
            }
            ToolbarView.principalItem(title: "설정")
        }
        .toolbarBackground(ColorConstants.gray6, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingView(
        store: Store(
            initialState: SettingFeature.State(),
            reducer: { SettingFeature()._printChanges() }
        )
    )
    .environmentObject(Router())
}
