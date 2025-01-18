//
//  ModalFriendView.swift
//  Presentation
//
//  Created by ukseung.dev on 1/16/25.
//

import SwiftUI
import ComposableArchitecture
import Domain

struct ModalFriendView: View {
    
    enum Constants {
        static let friendlessDescription = "아직 추가된 친구가 없어요"
        static let title = "경쟁할 친구를 선택해 주세요"
        static let competitionButtonTitle = "경쟁 요청하기"
    }
    
    @ObservedObject var viewStore: ViewStore<ModalFriendFeature.State, ModalFriendFeature.Action>
    let store: StoreOf<ModalFriendFeature>
    
    @Binding var selectedCompetitionFriend: Friend?
    @Environment(\.dismiss) var dismiss
    
    public init(store: StoreOf<ModalFriendFeature>, selectedFriend: Binding<Friend?>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
        self._selectedCompetitionFriend = selectedFriend
    }
    
    var body: some View {
        ZStack {
            ColorConstants.gray5.ignoresSafeArea()
            
            VStack {
                title
                
                Spacer()
                
                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
                
                competitionButton
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .onDisappear {
            viewStore.send(.onDisAppear)
        }
        .toastView(
            toast: viewStore.binding(
                get: \.toast,
                send: .dismissToast
            )
        )
    }
    
    @ViewBuilder
    var title: some View {
        HStack {
            Text(Constants.title)
                .foregroundStyle(.white)
                .font(.semiBold(20))
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
    }
    
    @ViewBuilder
    var contentView: some View {
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
                            viewType: .modalType,
                            friend: friend,
                            onButtonTapped: { friend in
                                viewStore.send(.selectedCompetitionFriend(friend))
                            })
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)) // 상하 여백 추가
                        .listRowBackground(ColorConstants.gray5)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden) // 기본 배경색 숨기기
                .background(ColorConstants.gray5)
            }
        } else {
            if viewStore.state.isLoading {
                ProgressView()
                    .tint(ColorConstants.gray3)
                    .allowsHitTesting(false)
            } else {
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
    
    @ViewBuilder
    var competitionButton: some View {
        Button {
            selectedCompetitionFriend = viewStore.state.selectedFriend
            dismiss()
        } label: {
            Text(Constants.competitionButtonTitle)
                .font(.semiBold(17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 54)
        .background(ColorConstants.primaryNormal)
        .cornerRadius(30)
        .padding(.top, 30)
        .padding(.horizontal, 55)
        .disabled(!viewStore.state.competitionButtonEnabled)
        .opacity(viewStore.state.competitionButtonEnabled ? 1.0 : 0.5)
    }
}
