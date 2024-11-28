//
//  Project.swift
//  dippin-iOSManifests
//
//  Created by inforex on 9/13/24.
//
// TEST

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.app(
    name: "App",
    dependencies: [
        .Module.domain,
        .Module.presentation,
        .Module.data,
        .Module.shared
    ],
    resources: .default
)
