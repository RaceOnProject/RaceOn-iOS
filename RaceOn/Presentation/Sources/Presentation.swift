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
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: 200, height: 200)
                .overlay {
                    Text("테스트")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
        }
        .ignoresSafeArea()
        .background(.white)
    }
}
