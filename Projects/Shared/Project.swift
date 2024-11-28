@preconcurrency import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Shared",
    targets: [
        .target(
            name: "Shared",
            destinations: Project.Environment.destinations,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).\(Project.Environment.appName).Shared",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [],
            settings: .settings(configurations: [.defaultDebug, .defaultRelease])
        ),
    ],
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)
