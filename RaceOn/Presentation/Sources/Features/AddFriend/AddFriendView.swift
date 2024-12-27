//
//  AddFriendView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/9/24.
//

import SwiftUI
import ComposableArchitecture
import UIKit

struct AddFriendView: View {
    
    enum Constants {
        static let title = "친구 코드를 입력해 주세요"
    }
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStore<AddFriendFeature.State, AddFriendFeature.Action>
    let store: StoreOf<AddFriendFeature>
    
    @FocusState private var focusedField: AddFriendFeature.State.Field?
    
    public init(store: StoreOf<AddFriendFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            ColorConstants.gray6
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    Spacer()
                        .frame(width: 20)
                    
                    Text(Constants.title)
                        .font(.bold(24))
                        .foregroundColor(.white)
                }
                
                Spacer()
                    .frame(height: 8)
                
                Spacer()
                
                HStack(spacing: 10) {
                    Spacer()
                        .frame(width: 10)
                    
                    ForEach(0..<6, id: \.self) { index in
                        AddFriendTextField(
                            text: viewStore.binding(
                                get: { $0.letters[index] },
                                send: { .writeLetter(index: index, text: $0) }
                            ),
                            onDeleteBackward: {
                                if index > 0 {
                                    viewStore.send(.writeLetter(index: index - 1, text: ""))
                                    focusedField = AddFriendFeature.State.Field(index - 1)
                                }
                            }
                        )
                            .frame(height: 66)
                            .focused($focusedField, equals: AddFriendFeature.State.Field(index))
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(
                                        focusedField == AddFriendFeature.State.Field(index) ? ColorConstants.primaryNormal : ColorConstants.gray5
                                    )
                                    .offset(y: 0),
                                alignment: .bottom
                            )
                            .onChange(of: viewStore.state.letters[index]) { newValue in
                                if newValue.count > 0 {
                                    focusedField = AddFriendFeature.State.Field(index + 1)
                                } else if newValue.count == 0, index > 0 {
                                    focusedField = AddFriendFeature.State.Field(index - 1)
                                }
                            }
                     }
                    
                    Spacer()
                        .frame(width: 10)
                }
                
                Spacer()
                
                AddFriendButton(
                    isButtonEnabled: viewStore.binding(
                        get: \.isButtonEnabled,
                        send: { _ in .noAction }
                    )
                ) {
                    viewStore.send(.addFriendButtonTapped)
                }
                
                Spacer()
                    .frame(height: 18)
            }
        }
        .onAppear {
            focusedField = .first
            viewStore.send(.onAppear)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewStore.send(.willEnterForeground)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarView.leadingItems {
                router.pop()
            }
            ToolbarView.principalItem(title: "친구 추가")
        }
        .toolbarBackground(ColorConstants.gray6, for: .navigationBar)
        .toastView(
            toast: viewStore.binding(
                get: \.toast,
                send: .dismissToast
            )
        )
    }
}

#Preview {
    AddFriendView(
        store: Store(
            initialState: AddFriendFeature.State(),
            reducer: { AddFriendFeature()._printChanges() }
        )
    )
    .environmentObject(Router())
}
