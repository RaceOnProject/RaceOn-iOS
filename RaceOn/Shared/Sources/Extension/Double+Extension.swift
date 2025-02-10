//
//  Double+Extension.swift
//  Shared
//
//  Created by ukseung.dev on 2/10/25.
//

public extension Double {
    public func roundedToDecimal(_ places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}
