// swift-tools-version: 5.8
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "Alamofire": .framework,
    "Moya": .framework,
    "KingFisher": .framework,
    "Lottie": .framework,
    "SwiftyJSON": .framework,
    "ComposableArchitecture": .framework
  ]
)
#endif

let package = Package(
  name: "RaceOn",
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
    .package(url: "https://github.com/Moya/Moya", from: "15.0.3"),
    .package(url: "https://github.com/onevcat/Kingfisher", from: "7.12.0"),
    .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
    .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.3")
  ]
)
