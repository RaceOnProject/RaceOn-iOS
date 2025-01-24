//
//  FriendView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import SwiftUI
import ComposableArchitecture

public struct FriendView: View {
    enum Constants {
        static let friendlessDescription = "아직 추가된 친구가 없어요"
    }
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStore<FriendFeature.State, FriendFeature.Action>
    let store: StoreOf<FriendFeature>
    
    public init(store: StoreOf<FriendFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            ColorConstants.gray6
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer().frame(width: 20)
                    
                    Button(action: {
                        router.pop()
                    }, label: {
                        ImageConstants.navigationBack24
                            .resizable()
                            .frame(width: 24, height: 24)
                    })
                    
                    Spacer()
                    
                    Text("친구 목록")
                        .font(.regular(17))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        router.push(screen: .addFriend)
                    }, label: {
                        ImageConstants.addFriend
                            .resizable()
                            .frame(width: 24, height: 24)
                    })
                    
                    Spacer().frame(width: 20)
                }
                .frame(height: 54)
                
                ZStack {
                    if let friendList = viewStore.friendList {
                        if friendList.isEmpty {
                            VStack {
                                ImageConstants.graphicNothing
                                    .resizable()
                                    .frame(width: 143.97, height: 180)
                                    .padding(.bottom, 16)
                                Text(Constants.friendlessDescription)
                                    .font(.semiBold(16))
                                    .foregroundColor(PresentationAsset.gray4.swiftUIColor)
                            }
                        } else {
                            List {
                                ForEach(friendList) { friend in
                                    FriendInfoView(
                                        viewType: .normalType,
                                        friend: friend,
                                        onButtonTapped: { friend in
                                            // Composable Architecture 액션 예시
                                            viewStore.send(.kebabButtonTapped(friend: friend))
                                        })
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)) // 상하 여백 추가
                                    .listRowBackground(ColorConstants.gray6)
                                }
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden) // 기본 배경색 숨기기
                            .background(ColorConstants.gray6)
                        }
                    } else {
                        if viewStore.state.isLoading {
                            ProgressView()
                                .tint(ColorConstants.gray3)
                                .allowsHitTesting(false)
                        } else {
                            VStack {
                                ImageConstants.graphicNothing
                                    .resizable()
                                    .frame(width: 143.97, height: 180)
                                    .padding(.bottom, 16)
                                Text(Constants.friendlessDescription)
                                    .font(.semiBold(16))
                                    .foregroundColor(PresentationAsset.gray4.swiftUIColor)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .disabled(viewStore.state.isLoading)
        .navigationDestination(for: Screen.self) { type in
            router.screenView(type: type)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .onDisappear {
            viewStore.send(.onDisappear)
        }
        .actionSheet(isPresented: Binding(
            get: { viewStore.state.isActionSheetPresented },
            set: { newValue in
                if !newValue {
                    viewStore.send(.dismissActionSheet) // ActionSheet dismiss 시 상태 리셋
                }
            }
        )) {
            ActionSheet(
                title: Text("\(viewStore.selectFriend?.friendNickname ?? "") 님에 대해"),
                message: nil,
                buttons: [
                    .destructive(Text("신고하기")) {
                        guard let selectFriend = viewStore.selectFriend else { return }
                        viewStore.send(.reportFriend(friend: selectFriend))
                    },
                    .destructive(Text("친구끊기")) {
                        guard let selectFriend = viewStore.selectFriend else { return }
                        viewStore.send(.unfriend(friend: selectFriend))
                    },
                    .cancel(Text("취소하기")) {
                        viewStore.send(.cancelButtonTapped)
                    }
                ]
            )
        }
        .toastView(
            toast: viewStore.binding(
                get: \.toast,
                send: .dismissToast
            )
        )
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FriendView(
        store: Store(
            initialState: FriendFeature.State(),
            reducer: { FriendFeature()._printChanges() }
        )
    )
    .environmentObject(Router())
}
