//
//  MyProfileView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/16/24.
//

import SwiftUI
import ComposableArchitecture

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
    
    @State private var nickname: String = ""
    
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
                    print("Photo Picker")
                }, label: {
                    ZStack(alignment: .bottomTrailing) {
                        
                        ImageConstants.profileDefault
                            .resizable()
                            .frame(width: 128, height: 128)
                        
                        ImageConstants.profileEditIcon
                            .frame(width: 36, height: 36)
                    }
                })
                
                Spacer().frame(height: 20)
                
                if viewStore.state.isEditing {
                    TextField(
                        "",
                        text: $nickname,
                        prompt: Text(viewStore.state.nickname)
                            .font(.semiBold(20))
                            .foregroundColor(ColorConstants.gray4)
                    )
                    .font(.semiBold(20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(height: 28)
                } else {
                    Text(viewStore.state.nickname)
                        .font(.semiBold(20))
                        .foregroundColor(.white)
                        .frame(height: 28)
                }
                
                Spacer().frame(height: 12)
                
                Button(action: {
                    viewStore.send(.copyButtonTapped)
                }, label: {
                    HStack(spacing: 4) {
                        Text("GD231E")
                            .font(.semiBold(15))
                            .foregroundColor(.white)
                        
                        ImageConstants.copyIcon
                    }
                })
                .padding(14)
                .background(ColorConstants.gray5)
                .cornerRadius(30)
                
                Spacer()
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .toastView(
            toast: viewStore.binding(
                get: \.toast,
                send: .dismissToast
            )
        )
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarView.leadingItems {
                router.pop()
            }
            ToolbarView.principalItem(title: "내 프로필")
            
            if viewStore.state.isEditing { // 편집중
                ToolbarView.trailingItems(MyProfileTrailing.save.items) {
                    viewStore.send(.navigationTrailingButtonTapped(isEditing: false))
                }
            } else {
                ToolbarView.trailingItems(MyProfileTrailing.edit.items) {
                    viewStore.send(.navigationTrailingButtonTapped(isEditing: true))
                }
            }
        }
        .toolbarBackground(ColorConstants.gray6, for: .navigationBar)
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
