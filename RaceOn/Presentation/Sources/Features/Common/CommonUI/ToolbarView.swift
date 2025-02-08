//
//  ToolbarView.swift
//  Presentation
//
//  Created by ukBook on 12/15/24.
//

import SwiftUI

struct ToolbarView {
    static func leadingItems(label: Image = ImageConstants.navigationBack ,onBackButtonTap: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button(action: {
                onBackButtonTap()
            }, label: {
                label
            })
            .padding(10)
//            .border(Color.red, width: 1) // 터치 영역 표시
        }
    }
    
    static func principalItem(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.regular(17))
                .foregroundColor(.white)
//                .border(Color.red, width: 1) // 터치 영역 표시
        }
    }
    
    static func trailingItems(_ view: some View, onTrailingButtonTap: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: {
                onTrailingButtonTap()
            }, label: {
                view
            })
            .padding(10)
//            .border(Color.red, width: 1) // 터치 영역 표시
        }
    }
}
