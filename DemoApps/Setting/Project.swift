//
//  Project.swift
//  Manifests
//
//  Created by ukseung.dev on 12/12/24.
//

import Foundation

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.app(
    name: "SettingDemoApp",
    dependencies: [
        .Module.domain,
        .Module.presentation,
        .Module.data,
        .Module.shared
    ],
    resources: Project.Environment.resourceFile
)
