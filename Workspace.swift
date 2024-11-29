//
//  Workspace.swift
//  dippin-iOSManifests
//
//  Created by inforex on 9/13/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let workspace = Workspace(
    name: "RaceOn",
    projects: [
        .path(ProjectPath.app.rawValue),
        .path(ProjectPath.data.rawValue),
        .path(ProjectPath.domain.rawValue),
        .path(ProjectPath.presentation.rawValue),
        .path(ProjectPath.shared.rawValue)
    ]
)
