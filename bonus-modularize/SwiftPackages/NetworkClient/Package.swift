// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name = "NetworkClient"
private let msForWarningExpression = 50
private let msForWarningBody = 100

let package = Package(
    name: name,
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: name,
            targets: [name]),
    ],
    dependencies: [
      .package(url: "https://github.com/tlacan/R.swift/", branch: "xcstrings-7.7.0"),
      .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0")
    ],
    targets: [
        .target(
            name: name,
            dependencies: [
              .product(name: "RswiftLibrary", package: "R.swift")
            ],
            resources: [.process("Resources")],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-warn-long-expression-type-checking=\(msForWarningExpression)",
                              "-Xfrontend", "-warn-long-function-bodies=\(msForWarningBody)"])
            ],
            plugins: [
              .plugin(name: "RswiftGenerateInternalResources", package: "R.swift"),
              .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [Target.Dependency.byName(name: name)]
        ),
    ]
)
