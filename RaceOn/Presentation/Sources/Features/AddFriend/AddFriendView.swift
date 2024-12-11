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
        static let subTitle = "첫 번째 칸을 꾹 누르면 코드 붙여넣기가 가능해요"
        
        static let on = PresentationAsset.primaryNormal.swiftUIColor
        static let off = PresentationAsset.gray5.swiftUIColor
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
            CommonConstants.defaultBackgroundColor
                .ignoresSafeArea()
            
            VStack (alignment: .leading) {
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
                
                HStack {
                    Spacer()
                        .frame(width: 20)
                    
                    Text(Constants.subTitle)
                        .font(.regular(16))
                        .foregroundColor(PresentationAsset.gray3.swiftUIColor)
                }
                
                Spacer()
                
                HStack (spacing: 10){
                    Spacer()
                        .frame(width: 10)
                    
                    AddFriendTextField(
                        text: viewStore.binding(
                            get: \.firstLetter,
                            send: { .writeLetter(index: 0, text: $0) }
                    ))
                    .focused($focusedField, equals: .first)
                    .overlay(
                        Rectangle()
                            .frame(height: 1) // Border 두께 설정
                            .foregroundColor(focusedField == .first ? Constants.on : Constants.off)
                            .offset(y: 0), // TextField 하단으로 위치 조정
                        alignment: .bottom
                    )
                    .onChange(of: viewStore.state.firstLetter) { newValue in
                        if newValue.count > 0 {
                            focusedField = .second
                        }
                    }
                    
                    AddFriendTextField(text: viewStore.binding(
                        get: \.secondLetter,
                        send: { .writeLetter(index: 1, text: $0) }
                    ))
                    .focused($focusedField, equals: .second)
                    .overlay(
                        Rectangle()
                            .frame(height: 1) // Border 두께 설정
                            .foregroundColor(focusedField == .second ? Constants.on : Constants.off)
                            .offset(y: 0), // TextField 하단으로 위치 조정
                        alignment: .bottom
                    )
                    .onChange(of: viewStore.state.secondLetter) { newValue in
                        if newValue.count > 0 {
                            focusedField = .third
                        } else if newValue.count == 0 {
                            focusedField = .first
                        }
                    }
                    
                    AddFriendTextField(text: viewStore.binding(
                        get: \.thirdLetter,
                        send: { .writeLetter(index: 2, text: $0) }
                    ))
                    .focused($focusedField, equals: .third)
                    .overlay(
                        Rectangle()
                            .frame(height: 1) // Border 두께 설정
                            .foregroundColor(focusedField == .third ? Constants.on : Constants.off)
                            .offset(y: 0), // TextField 하단으로 위치 조정
                        alignment: .bottom
                    )
                    .onChange(of: viewStore.state.thirdLetter) { newValue in
                        if newValue.count > 0 {
                            focusedField = .fourth
                        } else if newValue.count == 0 {
                            focusedField = .second
                        }
                    }
                    
                    AddFriendTextField(text: viewStore.binding(
                        get: \.fourthLetter,
                        send: { .writeLetter(index: 3, text: $0) }
                    ))
                    .focused($focusedField, equals: .fourth)
                    .overlay(
                        Rectangle()
                            .frame(height: 1) // Border 두께 설정
                            .foregroundColor(focusedField == .fourth ? Constants.on : Constants.off)
                            .offset(y: 0), // TextField 하단으로 위치 조정
                        alignment: .bottom
                    )
                    .onChange(of: viewStore.state.fourthLetter) { newValue in
                        if newValue.count > 0 {
                            focusedField = .fifth
                        } else if newValue.count == 0 {
                            focusedField = .third
                        }
                    }

                    AddFriendTextField(text: viewStore.binding(
                        get: \.fifthLetter,
                        send: { .writeLetter(index: 4, text: $0) }
                    ))
                    .focused($focusedField, equals: .fifth)
                    .overlay(
                        Rectangle()
                            .frame(height: 1) // Border 두께 설정
                            .foregroundColor(focusedField == .fifth ? Constants.on : Constants.off)
                            .offset(y: 0), // TextField 하단으로 위치 조정
                        alignment: .bottom
                    )
                    .onChange(of: viewStore.state.fifthLetter) { newValue in
                        if newValue.count > 0 {
                            focusedField = .sixth
                        } else if newValue.count == 0 {
                            focusedField = .fourth
                        }
                    }
                    
                    AddFriendTextField(text: viewStore.binding(
                        get: \.sixthLetter,
                        send: { .writeLetter(index: 5, text: $0) }
                    ))
                    .focused($focusedField, equals: .sixth)
                    .overlay(
                        Rectangle()
                            .frame(height: 1) // Border 두께 설정
                            .foregroundColor(focusedField == .sixth ? Constants.on : Constants.off)
                            .offset(y: 0), // TextField 하단으로 위치 조정
                        alignment: .bottom
                    )
                    .onChange(of: viewStore.state.sixthLetter) { newValue in
                        if newValue.count == 0 {
                            focusedField = .fifth
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    router.pop()
                }, label: {
                    PresentationAsset.navigationBackButton.swiftUIImage
                })
                .padding(10)
            }
            ToolbarItem(placement: .principal) {
                Text("친구 추가")
                    .font(.regular(17))
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(CommonConstants.defaultBackgroundColor, for: .navigationBar)
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
