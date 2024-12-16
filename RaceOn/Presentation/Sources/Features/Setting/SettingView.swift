//
//  SettingView.swift
//  Presentation
//
//  Created by ukBook on 12/15/24.
//

import SwiftUI
import Presentation
import ComposableArchitecture

struct SettingView: View {
    
    @EnvironmentObject var router: Router
    
    
    var body: some View {
        Text("SettingView")
            .onTapGesture {
                router.pop()
            }
    }
}
