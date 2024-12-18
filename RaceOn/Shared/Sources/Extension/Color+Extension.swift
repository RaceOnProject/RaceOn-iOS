//
//  Color+Extension.swift
//  Shared
//
//  Created by inforex on 12/18/24.
//

import Foundation
import SwiftUI


public extension Color {
    init(r: CGFloat, g: CGFloat, b: CGFloat, a: Double = 1) {
        
        let calculatedRed: Double = r / 255.0
        let calculatedGreen: Double = g / 255.0
        let calculatedBlue: Double = b / 255.0
        
        self.init(red: calculatedRed, green: calculatedGreen, blue: calculatedBlue, opacity: a)
    }
    
    init(rgb: CGFloat, a: Double = 1) {
        
        let calculatedDouble: Double = rgb / 255.0
        
        self.init(red: calculatedDouble, green: calculatedDouble, blue: calculatedDouble, opacity: a)
    }
}
