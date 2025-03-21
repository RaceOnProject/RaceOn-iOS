//
//  Dependencies+SPM.swift
//  MyPlugin
//
//  Created by inforex on 9/13/24.
//
import Foundation
import ProjectDescription
/// import 할 수 있게 target 으로
///
/// Dependencies + SPM
public extension TargetDependency {
    static let moya: TargetDependency = .external(externalDependency: .moya)
    static let kingfisher: TargetDependency = .external(externalDependency: .kingfisher)
    static let lottie: TargetDependency = .external(externalDependency: .lottie)
    static let swiftyJson: TargetDependency = .external(externalDependency: .swiftyJson)
    static let composableArchitecture: TargetDependency = .external(externalDependency: .composableArchitecture)
    static let swiftyCrop: TargetDependency = .external(externalDependency: .swiftyCrop)
    static let kakaoSDK: TargetDependency = .external(externalDependency: .kakaoSDK)
    static let firebaseMessaging: TargetDependency = .external(externalDependency: .firebaseMessaging)
    static let naverMapSDK: TargetDependency = .external(externalDependency: .naverMapSDK)
    static let swiftStomp: TargetDependency = .external(externalDependency: .swiftStomp)
}


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


public enum ExternalDependency: String {
    case moya = "Moya"
    case kingfisher = "Kingfisher"
    case lottie = "Lottie"
    case swiftyJson = "SwiftyJSON"
    case composableArchitecture = "ComposableArchitecture"
    case swiftyCrop = "SwiftyCrop"
    case kakaoSDK = "KakaoSDK"
    case firebaseMessaging = "FirebaseMessaging"
    case naverMapSDK = "NaverMapSDK"
    case swiftStomp = "SwiftStomp"
}
