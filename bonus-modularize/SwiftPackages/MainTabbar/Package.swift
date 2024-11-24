// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let name = "MainTabbar"
private let internalPackages = ["DesignSystem"]
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
    dependencies: packageDependencies(),
    targets: [
        .target(
            name: name,
            dependencies: targetDependencies(),
            resources: [.process("Resources")],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-warn-long-expression-type-checking=\(msForWarningExpression)",
                              "-Xfrontend", "-warn-long-function-bodies=\(msForWarningBody)"])
            ],
            plugins: [
              .plugin(name: "RswiftGenerateInternalResources", package: "R.swift"),
              .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [Target.Dependency.byName(name: name)]
        ),
    ]
)

private func packageDependencies(internalPackages: [String] = internalPackages) -> [Package.Dependency] {
  var result = [
    Package.Dependency.package(url: "https://github.com/tlacan/R.swift/", branch: "xcstrings-7.7.0"),
    Package.Dependency.package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0"),
    Package.Dependency.package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
  ]
  internalPackages.forEach({ internalPackage in
    result.append(Package.Dependency.package(name: internalPackage, path: "../\(internalPackage)"))
  })
  return result
}

private func targetDependencies(internalPackages: [String] = internalPackages) -> [PackageDescription.Target.Dependency] {
  var result: [PackageDescription.Target.Dependency] = [
    PackageDescription.Target.Dependency.product(name: "RswiftLibrary", package: "R.swift"),
    PackageDescription.Target.Dependency(stringLiteral: "Swinject")
  ]
  internalPackages.forEach({ internalPackage in
    result.append(PackageDescription.Target.Dependency(stringLiteral: internalPackage))
  })
  return result
}
