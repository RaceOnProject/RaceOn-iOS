@preconcurrency import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: Project.Environment.destinations,
            product: .app,
            bundleId: "\(Project.Environment.bundlePrefix).\(Project.Environment.appName)",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: .presentation, projectPath: .presentation),
                .project(target: .data, projectPath: .data),
                .project(target: .domain, projectPath: .domain),
                .project(target: .shared, projectPath: .shared)
            ],
            settings: .settings(configurations: [.defaultDebug, .defaultRelease])
        ),
        .target(
            name: "RaceOnTests",
            destinations: Project.Environment.destinations,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).\(Project.Environment.appName)",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "App")],
            settings: .settings(configurations: [.defaultTest])
        ),
    ]
)

