//
//  Log.swift
//  Shared
//
//  Created by ukseung.dev on 2/7/25.
//

import Foundation

import Foundation

public func traceLog(_ description: String,
           fileName: String = #file,
           lineNumber: Int = #line,
           functionName: String = #function) {

    let traceString = "\(fileName.components(separatedBy: "/").last!) -> \(functionName) -> \(description) (line: \(lineNumber))"
    print(traceString)
}
