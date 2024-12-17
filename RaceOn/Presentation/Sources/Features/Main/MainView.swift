//
//  MainView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/4/24.
//

import SwiftUI
import Shared

public struct MainView: View {
    public init() {}
    @EnvironmentObject var router: Router
    
    public var body: some View {
        NavigationStack(path: $router.route) {
            ZStack {
                //TODO: 배경 그라데이션
                ColorConstants.gray5
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    topBar
                    
                    title
                    
                    distanceTabView
                    
                    startButton
                    
                    Spacer().frame(height: 76)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: Screen.self) { type in
                router.screenView(type: type)
            }
        }
    }
    
    @ViewBuilder
    var topBar: some View {
        ZStack {
            HStack {
                ImageConstants.graphicLogo
                    .resizable()
                    .frame(width: 90, height: 20.53)
                
                Spacer()
                
                HStack(spacing: 20) {
                    ImageConstants.iconFriends
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            router.push(screen: .friend)
                        }
                    
                    ImageConstants.iconSetting
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            router.push(screen: .setting)
                        }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 54)
    }
    
    @ViewBuilder
    var title: some View {
        HStack {
            Text("거리를 설정하고\n경쟁을 시작해보세요!")
                .foregroundStyle(.white)
                .font(.bold(24))
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    var distanceTabView: some View {
        
        ZStack {
            TabView {
                ImageConstants.card3km
                    .resizable()
                    .cornerRadius(24)
                    .aspectRatio(280/400, contentMode: .fit)
                    .padding(.horizontal, 55)
                    
                ImageConstants.card5km
                    .resizable()
                    .cornerRadius(24)
                    .aspectRatio(280/400, contentMode: .fit)
                    .padding(.horizontal, 55)
                
                ImageConstants.card10km
                    .resizable()
                    .cornerRadius(24)
                    .aspectRatio(280/400, contentMode: .fit)
                    .padding(.horizontal, 55)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack {
                ImageConstants.iconChevronLeft
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        print("왼쪽 탭")
                    }
                
                Spacer()
                
                ImageConstants.iconChevronRight
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        print("오른쪽 탭")
                    }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 50)
        
    }
    
    @ViewBuilder
    var startButton: some View {

        Button {
            router.push(screen: .friend)
        } label: {
            Text("경쟁할 친구 선택하기")
                .font(.semiBold(17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 54)
        .background(ColorConstants.primaryNormal)
        .cornerRadius(30)
        .padding(.top, 30)
        .padding(.horizontal, 55)
    }
}

#Preview {
    MainView()
        .environmentObject(Router())
}
