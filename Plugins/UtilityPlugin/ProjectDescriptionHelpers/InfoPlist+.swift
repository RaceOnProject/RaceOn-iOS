//
//  InfoPlist+.swift
//  MyPlugin
//
//  Created by inforex on 9/13/24.
//

import ProjectDescription

public extension ProjectDescription.InfoPlist {

    static let `defaultFile`: ProjectDescription.InfoPlist = .file(path: .relativeToRoot("Support/Info.plist"))
}
