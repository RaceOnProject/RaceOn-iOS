//
//  Project.swift
//  AppManifests
//
//  Created by ukBook on 1/19/25.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.app(
    name: "RunningDemoApp",
    dependencies: [
        .Module.domain,
        .Module.presentation,
        .Module.data,
        .Module.shared
    ],
    resources: Project.Environment.resourceFile
)
