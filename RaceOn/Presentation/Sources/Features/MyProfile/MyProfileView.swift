//
//  MyProfileView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/16/24.
//

import SwiftUI
import ComposableArchitecture
import SwiftyCrop
import Kingfisher

enum MyProfileTrailing {
    case edit
    case save
    
    var items: some View {
        switch self {
        case .edit:
            Text("편집")
                .font(.semiBold(15))
                .foregroundColor(.white)
        case .save:
            Text("저장")
                .font(.semiBold(15))
                .foregroundColor(ColorConstants.primaryNormal)
        }
    }
}

struct MyProfileView: View {
    @State private var isFirstAppear = true // 플래그 변수
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStore<MyProfileFeature.State, MyProfileFeature.Action>
    
    let store: StoreOf<MyProfileFeature>
    
    public init(store: StoreOf<MyProfileFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            ColorConstants.gray6.ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 30)
                
                Button(action: {
                    viewStore.send(.editButtonTapped)
                    viewStore.send(.setImagePickerPresented(isPresented: true))
                }, label: {
                    ZStack(alignment: .bottomTrailing) {
                        if let image = viewStore.state.selectedImage { // 이미지 select 했을때
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 128, height: 128)
                                .clipShape(.circle)
                        } else {
                            if let profileImageUrl = viewStore.state.profileImageUrl { // 서버 통신 후 memberInfo가 nil이 아니면
                                if let url = URL(string: profileImageUrl) {
                                    KFImage(url)
                                        .placeholder { progress in
                                            ProgressView(progress)
                                        }
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .clipShape(.circle)
                                } else { // URL이 유효하지 않을 때
                                    ImageConstants.profileDefault
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                }
                            } else { // 서버 통신 실패 시
                                ImageConstants.profileDefault
                                    .resizable()
                                    .frame(width: 128, height: 128)
                            }
                        }
                        
                        ImageConstants.profileEditIcon
                            .frame(width: 36, height: 36)
                    }
                })
                
                Spacer().frame(height: 20)
                
                if let nickname = viewStore.state.nickname {
                    if viewStore.state.isEditing {
                        TextField(
                            "",
                            text: viewStore.binding(
                                get: { _ in nickname },
                                send: { .editNickname($0) }
                            ),
                            prompt: Text(viewStore.state.originalNickname ?? .init())
                                .font(.semiBold(20))
                                .foregroundColor(ColorConstants.gray4)
                        )
                        .font(.semiBold(20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(height: 28)
                    } else {
                        Text(nickname)
                            .font(.semiBold(20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(height: 28)
                    }
                } else {
                    // TODO: 서버에서 memberInfo를 받아올수 없음, 기획에 문의
                }
                
                Spacer().frame(height: 12)
                
                if let memberCode = viewStore.state.memberCode {
                    if !viewStore.state.isEditing {
                        Button(action: {
                            viewStore.send(.copyButtonTapped)
                        }, label: {
                            HStack(spacing: 4) {
                                Text(memberCode)
                                    .font(.semiBold(15))
                                    .foregroundColor(.white)
                                
                                ImageConstants.copyIcon
                            }
                        })
                        .padding(14)
                        .background(ColorConstants.gray5)
                        .cornerRadius(30)
                    }
                } else {
                    // TODO: 서버에서 memberInfo를 받아올수 없음, 기획에 문의
                }
                
                Spacer()
            }
            
            if viewStore.state.isLoading {
                ProgressView()
                    .tint(ColorConstants.gray3)
                    .allowsHitTesting(false)
            }
        }
        .disabled(viewStore.state.isLoading)
        .onAppear {
            viewStore.send(.onAppear)
            isFirstAppear = false // 이후에는 호출되지 않도록 플래그 업데이트
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .sheet(
            isPresented: viewStore.binding(
                get: \.showImagePicker,
                send: { .setImagePickerPresented(isPresented: $0) }
            )
        ) {
            ImagePicker(
                image: viewStore.binding(
                    get: \.selectedImage,
                    send: { .setSelectedImage(image: $0 ?? UIImage()) }
                ),
                isCroppingPresented: viewStore.binding(
                    get: \.isCroppingPresented,
                    send: .setIsCroppingPresented(isPresented: true)
                )
            )
        }
        .fullScreenCover(
            isPresented: viewStore.binding(
                get: \.isCroppingPresented,
                send: { .setIsCroppingPresented(isPresented: $0) }
            ),
            content: {
                ZStack {
                    ColorConstants.gray6
                        .ignoresSafeArea()
                    
                    if let imageToCrop = viewStore.state.selectedImage {
                        SwiftyCropView(
                            imageToCrop: imageToCrop,
                            maskShape: .circle,
                            configuration: SwiftyCropConfiguration(
                                texts: SwiftyCropConfiguration.Texts(
                                    cancelButton: "취소",
                                    interactionInstructions: "프로필 수정",
                                    saveButton: "확인"
                                )
                            )
                        ) { croppedImage in
                            if let croppedImage = croppedImage {
                                viewStore.send(.setSelectedImage(image: croppedImage))
                            }
                        }
                    }
                }
            })
        .toastView(
            toast: viewStore.binding(
                get: \.toast,
                send: .dismissToast
            )
        )
        .toolbar {
            ToolbarView.leadingItems {
                router.pop()
            }
            ToolbarView.principalItem(title: "내 프로필")
            
            if viewStore.state.isEditing { // 편집중
                ToolbarView.trailingItems(MyProfileTrailing.save.items) {
                    viewStore.send(.saveButtonTapped)
                }
            } else {
                ToolbarView.trailingItems(MyProfileTrailing.edit.items) {
                    viewStore.send(.editButtonTapped)
                }
            }
        }
        .toolbarBackground(ColorConstants.gray6, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MyProfileView(
        store: Store(
            initialState: MyProfileFeature.State(),
            reducer: { MyProfileFeature()._printChanges() }
        )
    )
    .environmentObject(Router())
}
