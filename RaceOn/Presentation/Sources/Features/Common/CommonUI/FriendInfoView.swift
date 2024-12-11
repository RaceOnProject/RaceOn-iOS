//
//  FriendInfoView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import SwiftUI

struct FriendInfoView: View {
    var onKebabTapped: () -> Void // 버튼이 눌렸을 때 실행될 클로저

    var body: some View {
        ZStack {
            CommonConstants.defaultBackgroundColor
            
            HStack {
                Spacer()
                    .frame(width: 20)
                
                ZStack(alignment: .bottomTrailing) { // ZStack을 우하단 정렬로 설정
                    PresentationAsset.profile2.swiftUIImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle()) // 이미지를 동그랗게 클리핑
                    
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(PresentationAsset.primaryNormal.swiftUIColor)
                        .overlay( // 테두리를 추가
                            Circle()
                                .stroke(Color.clear, lineWidth: 2) // 테두리 색상과 두께 설정
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("김지호")
                        .font(.semiBold(17))
                        .foregroundColor(.white)
                    Text("접속 중")
                        .font(.regular(14))
                        .foregroundColor(PresentationAsset.gray4.swiftUIColor)
                }
                
                Spacer()
                
                Button(action: {
                    onKebabTapped()
                }) {
                    PresentationAsset.kebab.swiftUIImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 2.87, height: 17)
                }
                .padding(20) // 이미지 주변에 패딩 추가
            }
        }
    }
}

#Preview {
    FriendInfoView {
        print("Kekebab Touch")
    }
}
