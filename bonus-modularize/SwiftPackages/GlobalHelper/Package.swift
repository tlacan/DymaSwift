// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name = "GlobalHelper"
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
      .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0")
    ],
    targets: [
        .target(
            name: name,
            swiftSettings: swiftSettingsFlags(),
            plugins: [
              .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [Target.Dependency.byName(name: name)]
        ),
    ]
)

private func swiftSettingsFlags() -> [SwiftSetting] {
  [.unsafeFlags([
    "-Xfrontend", "-warn-long-expression-type-checking=\(msForWarningExpression)",
    "-Xfrontend", "-warn-long-function-bodies=\(msForWarningBody)",
    "-Xfrontend", "-warn-concurrency",
    "-Xfrontend", "-enable-actor-data-race-checks"
   ])]
}

