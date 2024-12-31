// swift-tools-version: 5.8
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "Moya": .framework,
    "KingFisher": .framework,
    "Lottie": .framework,
    "SwiftyJSON": .framework,
    "ComposableArchitecture": .framework,
    "SwiftyCrop": .framework,
    "KakaoSDK": .framework,
    "FirebaseMessaging": .staticFramework
  ]
)
#endif

let package = Package(
  name: "RaceOn",
  dependencies: [
    .package(url: "https://github.com/Moya/Moya", from: "15.0.3"),
    .package(url: "https://github.com/onevcat/Kingfisher", from: "7.12.0"),
    .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
    .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.3"),
    .package(url: "https://github.com/benedom/SwiftyCrop", branch: "master"),
    .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.6.0")
  ]
)
