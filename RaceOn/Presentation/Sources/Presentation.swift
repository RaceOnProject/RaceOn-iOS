//
//  Test.swift
//  App
//
//  Created by inforex on 9/13/24.
//

import Foundation
import SwiftUI

public struct TestView: View {
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .foregroundStyle(Color(hex: "FEE500"))
                .frame(width: 350, height: 54)
                .overlay {
                    Button("카카오로 로그인") {
                        // 버튼 액션
                    }
                    .foregroundStyle(.black)
                }
                .cornerRadius(30)
                .padding(.bottom, 12)
            
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: 350, height: 54)
                .overlay {
                    Button("Continue with Apple") {
                        // 버튼 액션
                    }
                    .foregroundStyle(.white)
                }
                .cornerRadius(30)
                .padding(.bottom, 20)
        }
        .background(.white)
    }
}
