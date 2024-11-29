//
//  Project+Extensions.swift
//  DependencyPlugin
//
//  Created by ukseung.dev on 11/27/24.
//

@preconcurrency import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "RaceOn"
        public static let destinations: Destinations = [.iPhone]
        public static let deploymentTarget: DeploymentTargets = .iOS("16.0")
        public static let bundlePrefix = "com.undefined"
        public static let featureProductType = ProjectDescription.Product.staticLibrary
        public static let infoPlist: ProjectDescription.InfoPlist = .file(path: .relativeToRoot("Support/Info.plist"))
        public static let resourceFile: ProjectDescription.ResourceFileElements = ["Resources/**"]
    }
}

