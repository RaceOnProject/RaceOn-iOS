//
//  Workspace.swift
//  RaceOnManifests
//
//  Created by ukseung.dev on 11/27/24.
//

@preconcurrency import ProjectDescription
import DependencyPlugin

let workspace = Workspace(
    name: "RaceOnWorkspace",
    projects: [
        .path(ProjectPath.app.rawValue),
        .path(ProjectPath.data.rawValue),
        .path(ProjectPath.domain.rawValue),
        .path(ProjectPath.presentation.rawValue),
        .path(ProjectPath.shared.rawValue)
    ],
    generationOptions: .options(lastXcodeUpgradeCheck: .init(16, 1, 0))
)

