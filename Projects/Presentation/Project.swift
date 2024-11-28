@preconcurrency import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Presentation",
    targets: [
        .target(
            name: "Presentation",
            destinations: Project.Environment.destinations,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).\(Project.Environment.appName).Presentation",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
            ],
            settings: .settings(configurations: [.defaultDebug, .defaultRelease])
        ),
    ],
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)
