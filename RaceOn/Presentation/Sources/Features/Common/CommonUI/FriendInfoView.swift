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

enum FriendViewType {
    case modalType
    case normalType
    
    var backgroundColor: SwiftUI.Color {
        switch self {
        case .modalType:
            return ColorConstants.gray5
        case .normalType:
            return ColorConstants.gray6
        }
    }
}

struct FriendInfoView: View {
    
    var viewType: FriendViewType
    var friend: Friend
    var onButtonTapped: (Friend) -> Void // 버튼이 눌렸을 때 실행될 클로저

    var body: some View {
        ZStack {
            viewType.backgroundColor.ignoresSafeArea()
            
            HStack {
                Spacer()
                    .frame(width: 20)
                
                ZStack(alignment: .bottomTrailing) { // ZStack을 우하단 정렬로 설정
                    if let url = URL(string: friend.profileImageUrl) {
                        KFImage(url)
                            .placeholder { progress in
                                ProgressView(progress)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle()) // 이미지를 동그랗게 클리핑
                    } else {
                        ImageConstants.profileDefault
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    }
                    
                    if friend.playing || timeAgo(from: friend.lastActiveAt) == "접속 중" {
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
                
                switch viewType {
                case .modalType:
                    Button(action: {
                        onButtonTapped(friend)
                    }, label: {
                        if friend.selected {
                            ImageConstants.circleCheckFill
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                        } else {
                            ImageConstants.circleCheck
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                        }
                    })
                    .padding(20) // 이미지 주변에 패딩 추가
                case .normalType:
                    Button(action: {
                        onButtonTapped(friend)
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
}
