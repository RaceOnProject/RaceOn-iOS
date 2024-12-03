//
//  Color+Extension.swift
//  Presentation
//
//  Created by 박시현 on 12/3/24.
//

import SwiftUI

extension Color {
   init(hex: String) {
       let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
       var int: UInt64 = 0
       Scanner(string: hex).scanHexInt64(&int)
       let r = Double((int & 0xFF0000) >> 16) / 255.0
       let g = Double((int & 0x00FF00) >> 8) / 255.0
       let b = Double(int & 0x0000FF) / 255.0
       self.init(red: r, green: g, blue: b)
   }
}
