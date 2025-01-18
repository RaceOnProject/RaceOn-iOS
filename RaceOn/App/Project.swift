//
//  Project.swift
//  dippin-iOSManifests
//
//  Created by inforex on 9/13/24.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.app(
    name: Project.Environment.appName,
    dependencies: [
        .Module.domain,
        .Module.presentation,
        .Module.data,
        .Module.shared
    ],
    resources: Project.Environment.resourceFile,
    entitlements: .dictionary(
        [
            "aps-environment" : .string("development"),
            "com.apple.developer.applesignin" : .string("default")
        ]
    )
)
