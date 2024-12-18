//
//  View+Extension.swift
//  Shared
//
//  Created by ukseung.dev on 12/9/24.
//

import SwiftUI

// ActionSheet에 필요한 버튼 유형 정의
public enum ActionSheetButton {
    case defaultButton(title: String, action: () -> Void)
    case cancel(title: String, action: () -> Void)
}

// ActionSheet를 생성하는 익스텐션
public extension View {
    func actionSheet(
        isPresented: Binding<Bool>,
        title: String?,
        message: String?,
        buttons: [ActionSheetButton]
    ) -> some View {
        self.actionSheet(isPresented: isPresented) {
            ActionSheet(
                title: Text(title ?? ""),
                message: message.map { Text($0) },
                buttons: buttons.map { button in
                    switch button {
                    case .defaultButton(let title, let action):
                        return .default(Text(title), action: action)
                    case .cancel(let title, let action):
                        return .cancel(Text(title), action: action)
                    }
                }
            )
        }
    }
    
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
