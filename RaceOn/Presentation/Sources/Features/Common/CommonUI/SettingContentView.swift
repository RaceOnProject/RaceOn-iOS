//
//  SettingContentView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/16/24.
//

import SwiftUI

struct SettingContentView: View {
    
    var type: SettingCategory
    @State var competitionInvites: Bool = true
    @Binding var appVersion: String?
    
    var body: some View {
        HStack {
            Text(type.title)
                .font(.regular(17))
                .foregroundColor(.white)
            
            Spacer()
            
            switch type {
            case .myProfile, .termsOfService, .privacyPolicy:
                ImageConstants.chevronCompactRight
            case .competitionInvites:
                Toggle(isOn: $competitionInvites) {
                    Text("경쟁 초대 알림")
                        .font(.regular(15))
                        .foregroundColor(.white)
                }
                .tint(ColorConstants.primaryNormal)
                .frame(width: 54, height: 30)
            case .appInfo:
                if let appVersion = appVersion {
                    Text("현재 버전 \(appVersion)")
                        .font(.regular(15))
                        .foregroundColor(.white)
                } else {
                    Text("버전을 가져오는데 실패하였습니다.")
                        .font(.regular(15))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 20)
        .background(ColorConstants.gray6)
    }
}

#Preview {
    @State var appVersion: String? = "1.0.0"
    
    return SettingContentView(
        type: .appInfo,
        appVersion: $appVersion
    )
}
