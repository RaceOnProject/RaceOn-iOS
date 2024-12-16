//
//  MyProfileView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/16/24.
//

import SwiftUI
import ComposableArchitecture

struct MyProfileView: View {
    
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
                Text("MyProfileView").foregroundColor(.white)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarView.leadingItems {
                router.pop()
            }
            ToolbarView.principalItem(title: "내 프로필")
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
