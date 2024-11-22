import ProjectDescription

let project = Project(
    name: "RaceOn",
    options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    ),
    packages: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMajor(from: "0.8.0")
        ),
        .remote(
            url: "https://github.com/Moya/Moya.git",
            requirement: .branch("master")
        ),
        .remote(
            url: "https://github.com/onevcat/Kingfisher",
            requirement: .branch("master")
        ),
        .remote(
            url: "https://github.com/no-comment/KeyboardToolbar.git",
            requirement: .branch("main")
        )
    ],
    targets: [
        .target(
            name: "RaceOn",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.RaceOn",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["RaceOn/Sources/**"],
            resources: ["RaceOn/Resources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
                .package(product: "Moya"),
                .package(product: "Kingfisher"),
                .package(product: "KeyboardToolbar")
            ],
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug"),
                    .debug(name: "QA"),
                    .release(name: "Release"),
                ]
            )
        ),
        .target(
            name: "RaceOnTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.RaceOnTests",
            infoPlist: .default,
            sources: ["RaceOn/Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "RaceOn"),
                .package(product: "ComposableArchitecture"),
                .package(product: "Moya"),
                .package(product: "Kingfisher"),
                .package(product: "KeyboardToolbar")
            ]
        ),
    ]
)
