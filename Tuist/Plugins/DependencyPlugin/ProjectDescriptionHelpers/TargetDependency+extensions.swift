//
//  TargetDependency+extensions.swift
//  DependencyPlugin
//
//  Created by ukseung.dev on 11/27/24.
//

import Foundation
import ProjectDescription

extension TargetDependency {
  public static func external(externalDependency: ExternalDependency) -> TargetDependency {
    return .external(name: externalDependency.rawValue)
  }
  
  public static func target(name: TargetName) -> TargetDependency {
    return .target(name: name.rawValue)
  }
  
  public static func project(target: TargetName, projectPath: ProjectPath) -> TargetDependency {
    return .project(
      target: target.rawValue,
      path: .relativeToRoot(projectPath.rawValue)
    )
  }
}

public enum ProjectPath: String {
    case app = "Projects/App"
    case data = "Projects/Data"
    case domain = "Projects/Domain"
    case presentation = "Projects/Presentation"
    case shared = "Projects/Shared"
}

public enum TargetName: String {
    case app = "App"
    case data = "Data"
    case domain = "Domain"
    case presentation = "Presentation"
    case shared = "Shared"
}

public enum ExternalDependency: String {
  case composableArchitecture = "ComposableArchitecture"
}
