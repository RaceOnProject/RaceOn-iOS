//
//  AllowAccess.swift
//  Presentation
//
//  Created by inforex on 12/23/24.
//

import SwiftUI
import CoreLocation

import ComposableArchitecture

public enum Access {
    case location
    case activity
    case alarm
    case gallery
    
    public var title: String {
        switch self {
        case .location: return "위치"
        case .activity: return "신체 활동"
        case .alarm: return "알림"
        case .gallery: return "사진"
        }
    }
    
    public var description: String {
        switch self {
        case .location: return "달리기 경쟁 서비스에 사용"
        case .activity: return "달리기 속도 측정에 사용"
        case .alarm: return "달리기 경쟁 초대 시 알림 제공"
        case .gallery: return "프로필 사진 업로드 시 사용"
        }
    }
    
    public var icon: Image {
        switch self {
        case .location: return ImageConstants.iconLocation
        case .activity: return ImageConstants.iconActivity
        case .alarm: return ImageConstants.iconAlarm
        case .gallery: return ImageConstants.iconGallery
        }
    }
}

public struct AllowAccessView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStoreOf<AllowAccessFeature>
    let store: StoreOf<AllowAccessFeature>
    
    public init(store: StoreOf<AllowAccessFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            ColorConstants.gray6
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                title
                
                essentialAccess
                
                optionalAccess
                
                Spacer()
                
                description
                
                confirmButton
            }
            .padding(.horizontal, 20)
        }
        .onAppear(perform: {
            viewStore.send(.requestAuthorization)
        })
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    var title: some View {
        Text("RACE ON 서비스 이용을 위해\n다음 권한 허용이 필요해요")
            .foregroundStyle(.white)
            .font(.bold(24))
            .multilineTextAlignment(.leading)
            .padding(.leading, -4)
            .padding(.top, 82)
    }
    
    @ViewBuilder
    var essentialAccess: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("필수 접근 권한")
                .foregroundStyle(ColorConstants.gray2)
                .font(.semiBold(15))
            
            accessRow(access: .location)
        }
        .padding(.top, 40)
    }
    
    @ViewBuilder
    var optionalAccess: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("선택 접근 권한")
                .foregroundStyle(ColorConstants.gray2)
                .font(.semiBold(15))
            
            accessRow(access: .activity)
            
            accessRow(access: .alarm)
            
            accessRow(access: .gallery)
        }
        .padding(.top, 32)
    }
    
    @ViewBuilder
    func accessRow(access: Access) -> some View {
        HStack(alignment: .top, spacing: 8) {
            access.icon
                .resizable()
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(access.title)
                    .font(.semiBold(17))
                    .foregroundStyle(.white)
                
                Text(access.description)
                    .font(.regular(14))
                    .foregroundStyle(ColorConstants.gray3)
            }
        }
        .frame(height: 46)
    }
    
    @ViewBuilder
    var description: some View {
        Text("*선택 권한의 경우, 허용하지 않아도 서비스를 이용할 수 있으나 일부 서비스 이용에 제한이 있을 수 있습니다.\n*'설정'에서 각 권한별 변경이 가능합니다.")
            .foregroundStyle(ColorConstants.gray3)
            .font(.regular(14))
            .multilineTextAlignment(.leading)
    }
    
    @ViewBuilder
    var confirmButton: some View {
        Button {
            moveToMainView()
        } label: {
            Text("확인")
                .font(.semiBold(17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 54)
        .background(ColorConstants.primaryNormal)
        .cornerRadius(30)
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
    }
    
    /// window의 rootViewController MainView로 교체
    func moveToMainView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Failed to find the key window.")
            return
        }
        
        let mainView = MainView().environmentObject(Router())
        let mainVC = UIHostingController(rootView: mainView)
        window.rootViewController = mainVC
        
        // 애니메이션 추가 (선택사항)
        UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil)
    }
}

#Preview {
    AllowAccessView(
        store: Store(
            initialState: AllowAccessFeature.State(),
            reducer: { AllowAccessFeature()._printChanges() }
        )
    )
}
