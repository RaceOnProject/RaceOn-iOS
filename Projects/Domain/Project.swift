@preconcurrency import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: Project.Environment.destinations,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).\(Project.Environment.appName).Domain",
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
