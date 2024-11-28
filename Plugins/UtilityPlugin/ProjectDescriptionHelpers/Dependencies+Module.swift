//
//  Dependencies+Module.swift
//  MyPlugin
//
//  Created by inforex on 9/13/24.
//

import ProjectDescription


/// Dependencies + Module
extension TargetDependency {
    public enum Module {}
}

extension TargetDependency.Module {
    public static let domain = TargetDependency.project(target: "Domain", path: .relativeToRoot("RaceOn/Domain"))
    public static let presentation = TargetDependency.project(target: "Presentation", path: .relativeToRoot("RaceOn/Presentation"))
    public static let data = TargetDependency.project(target: "Data", path: .relativeToRoot("RaceOn/Data"))
    public static let shared = TargetDependency.project(target: "Shared", path: .relativeToRoot("RaceOn/Shared"))
}
