//
//  Dependencies+SPM.swift
//  MyPlugin
//
//  Created by inforex on 9/13/24.
//

import ProjectDescription
/// import 할 수 있게 target 으로
///
/// Dependencies + SPM
public extension TargetDependency {
    static let alamofire: TargetDependency  = .external(name: "Alamofire")
    static let moya: TargetDependency = .external(name: "Moya")
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
    static let lottie: TargetDependency = .external(name: "Lottie")
    static let swiftyJson: TargetDependency = .external(name: "SwiftyJSON")
    static let composableArchitecture: TargetDependency = .external(name: "ComposableArchitecture")
}
