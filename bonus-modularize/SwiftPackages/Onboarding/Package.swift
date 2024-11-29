// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let name = "Onboarding"
private let internalPackages = ["DesignSystem", "NetworkClient"]
private let domainLayer = "\(name)Domain"
private let dataLayer = "\(name)Data"
private let uiLayer = "\(name)UI"
private let msForWarningExpression = 50
private let msForWarningBody = 100

let package = Package(
    name: name,
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: name,
            targets: [uiLayer])
    ],
    dependencies: packageDependencies(),
    targets: [
        .target(
            name: "\(name)UI",
            dependencies: [
              "DesignSystem",
              .product(name: "RswiftLibrary", package: "R.swift"),
              .target(name: dataLayer)
            ],
            resources: [.process("Resources")],
            swiftSettings: swiftSettingsFlags(),
            plugins: [
              .plugin(name: "RswiftGenerateInternalResources", package: "R.swift"),
              .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(name: domainLayer,
            swiftSettings: swiftSettingsFlags(),
            plugins: [
              .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(name: dataLayer,
            dependencies: targetDependencies(internalPackages: ["NetworkClient", domainLayer]),
            swiftSettings: swiftSettingsFlags(),
            plugins: [
              .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
         ),
        .testTarget(
            name: "\(uiLayer)Tests",
            dependencies: [Target.Dependency.byName(name: uiLayer)],
            swiftSettings: swiftSettingsFlags()
        ),
        .testTarget(
            name: "\(domainLayer)Tests",
            dependencies: [Target.Dependency.byName(name: domainLayer)],
            swiftSettings: swiftSettingsFlags()
        ),
        .testTarget(
            name: "\(dataLayer)Tests",
            dependencies: [Target.Dependency.byName(name: dataLayer)],
            swiftSettings: swiftSettingsFlags()
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

private func packageDependencies(internalPackages: [String] = internalPackages) -> [Package.Dependency] {
  var result = [
    Package.Dependency.package(url: "https://github.com/tlacan/R.swift/", branch: "xcstrings-7.7.0"),
    Package.Dependency.package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0"),
  ]
  internalPackages.forEach({ internalPackage in
    result.append(Package.Dependency.package(name: internalPackage, path: "../\(internalPackage)"))
  })
  return result
}

private func targetDependencies(internalPackages: [String] = internalPackages) -> [PackageDescription.Target.Dependency] {
  var result: [PackageDescription.Target.Dependency] = []
  internalPackages.forEach({ internalPackage in
    result.append(PackageDescription.Target.Dependency(stringLiteral: internalPackage))
  })
  return result
}
