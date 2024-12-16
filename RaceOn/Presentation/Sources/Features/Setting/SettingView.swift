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
        // TODO: notion 완성 되면 변경 할 것.
        case .termsOfService: return "https://www.google.com"
        case .privacyPolicy: return "https://www.naver.com"
        default: return ""
        }
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
                        case .myProfile: print("myProfile")
                        case .termsOfService, .privacyPolicy:
                            router.push(screen: .legalNotice(type: settings))
                        default: break
                        }
                    }, label: {
                        SettingContentView(
                            type: settings,
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
                        print("로그아웃")
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
                        print("회원탈퇴")
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
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarView.leadingItems {
                router.pop()
            }
            ToolbarView.principalItem(title: "설정")
        }
        .toolbarBackground(ColorConstants.gray6, for: .navigationBar)
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
