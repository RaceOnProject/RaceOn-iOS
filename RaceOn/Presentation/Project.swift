//
//  Project.swift
//  dippin-iOSManifests
//
//  Created by inforex on 9/13/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.framework(
    name: "Presentation",
    dependencies: [
        .Module.domain,
        .Module.shared
    ],
    resources: Project.Environment.resourceFile
    
)
