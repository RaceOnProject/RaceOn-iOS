//
//  Color+Extension.swift
//  Shared
//
//  Created by inforex on 12/18/24.
//

import Foundation
import SwiftUI

public extension Color {
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: Double = 1) {
        
        let calculatedRed: Double = red / 255.0
        let calculatedGreen: Double = green / 255.0
        let calculatedBlue: Double = blue / 255.0
        
        self.init(red: calculatedRed, green: calculatedGreen, blue: calculatedBlue, opacity: alpha)
    }
    
    init(rgb: CGFloat, alpha: Double = 1) {
        
        let calculatedDouble: Double = rgb / 255.0
        
        self.init(red: calculatedDouble, green: calculatedDouble, blue: calculatedDouble, opacity: alpha)
    }
}
