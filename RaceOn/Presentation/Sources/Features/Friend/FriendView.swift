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
            
            if viewStore.tData.isEmpty {
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
                    ForEach(viewStore.tData) { _ in
                        FriendInfoView(onKebabTapped: {
                            viewStore.send(.kebabButtonTapped) // Composable Architecture 액션 예시
                        })
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)) // 상하 여백 추가
                        .listRowBackground(ColorConstants.gray6)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden) // 기본 배경색 숨기기
                .background(ColorConstants.gray6)
            }
        }
        .navigationDestination(for: Screen.self) { type in
            router.screenView(type: type)
        }
        .onAppear {
            viewStore.send(.testAction)
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
                title: Text("알림"),
                message: nil,
                buttons: [
                    .destructive(Text("신고하기")) {
                        print("신고하기")
                    },
                    .destructive(Text("친구끊기")) {
                        print("친구끊기")
                    },
                    .cancel(Text("취소하기"))
                ]
            )
        }
        .navigationBarItems(
            leading:
                Button(action: {
                    router.pop()
                }, label: {
                    ImageConstants.navigationBack
                })
                .padding(10), // 터치 영역 확장
            trailing:
                Button(action: {
                    router.push(screen: .addFriend)
                }, label: {
                    ImageConstants.addFriend
                })
                .padding(10) // 터치 영역 확장
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("친구 목록")
                    .font(.regular(17))
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(ColorConstants.gray6, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
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
