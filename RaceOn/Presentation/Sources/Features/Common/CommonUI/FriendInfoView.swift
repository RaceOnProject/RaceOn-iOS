//
//  FriendInfoView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import SwiftUI
import Domain
import Shared
import Kingfisher

struct FriendInfoView: View {
    var friend: Friend
    var onKebabTapped: () -> Void // 버튼이 눌렸을 때 실행될 클로저

    var body: some View {
        ZStack {
            ColorConstants.gray6
            
            HStack {
                Spacer()
                    .frame(width: 20)
                
                ZStack(alignment: .bottomTrailing) { // ZStack을 우하단 정렬로 설정
                    KFImage.url(URL(string: friend.profileImageUrl)!)
                        .placeholder { progress in
                            ProgressView(progress)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle()) // 이미지를 동그랗게 클리핑
                    
                    if friend.playing {
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundColor(ColorConstants.primaryNormal)
                            .overlay( // 테두리를 추가
                                Circle()
                                    .stroke(Color.clear, lineWidth: 2) // 테두리 색상과 두께 설정
                            )
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(friend.friendNickname)
                        .font(.semiBold(17))
                        .foregroundColor(.white)
                    Text(timeAgo(from: friend.lastActiveAt))
                        .font(.regular(14))
                        .foregroundColor(ColorConstants.gray4)
                }
                
                Spacer()
                
                Button(action: {
                    onKebabTapped()
                }, label: {
                    ImageConstants.kebab
                        .resizable()
                        .scaledToFill()
                        .frame(width: 2.87, height: 17)
                })
                .padding(20) // 이미지 주변에 패딩 추가
            }
        }
    }
}
