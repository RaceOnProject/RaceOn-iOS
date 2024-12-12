//
//  Project+Script.swift
//  UtilityPlugin
//
//  Created by inforex on 12/9/24.
//

@preconcurrency import ProjectDescription

public extension TargetScript {
    static let swiftlintScript: Self = .pre(
        script: """
        export PATH="$PATH:/opt/homebrew/bin"
        if which swiftlint > /dev/null; then
          swiftlint
        else
          echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
        fi    
        """,
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
    )
}
