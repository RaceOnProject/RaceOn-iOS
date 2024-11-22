import ProjectDescription

let project = Project(
    name: "RaceOn",
    targets: [
        .target(
            name: "RaceOn",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.RaceOn",
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
            dependencies: []
        ),
        .target(
            name: "RaceOnTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.RaceOnTests",
            infoPlist: .default,
            sources: ["RaceOn/Tests/**"],
            resources: [],
            dependencies: [.target(name: "RaceOn")]
        ),
    ]
)
