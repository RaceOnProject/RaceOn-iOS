//
//  Project+Setting.swift
//  DependencyPlugin
//
//  Created by ukseung.dev on 11/27/24.
//

@preconcurrency import ProjectDescription

public extension Settings {
    static let defaultSettings: Self = {
        .settings(configurations: [
            .defaultRelease,
            .defaultDebug,
            .defaultTest
        ])
    }()
}

