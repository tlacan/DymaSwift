import ProjectDescription

private let bundleId = "io.tuist.tripManagerTwist"
private let version = "0.0.1"
private let bundleVersion = "1"
private let appName = "tripManagerTwist"
private let iOSTargerVersion = "17.0"
private let basePath = "Targets/\(appName)"
private let swiftPackagesPath = "SwiftPackages"
private let internalPackages: [String] = [
  "NetworkClient",
  "DesignSystem",
  "Onboarding",
  "MainTabbar",
  "CityActivities"
]
private let msForWarningExpression = 50
private let msForWarningBody = 100

let project = Project(
    name: appName,
    packages: packages(),
    settings: Settings.settings(configurations: makeConfigurations()),
    targets: [
        .target(
            name: appName,
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS(iOSTargerVersion),
            infoPlist: makeInfoPList(),
            sources: ["\(basePath)/Sources/**"],
            resources: ["\(basePath)/Resources/**"],
            dependencies: dependencies(),
            settings: baseSettings()
        ),
    ],
    additionalFiles: [
      "README.md"
    ]
)

private func dependencies() -> [ProjectDescription.TargetDependency] {
  var result = internalPackages.map({
    ProjectDescription.TargetDependency.package(product: $0)
  })
  result.append(contentsOf: [
    .package(product: "Swinject")
  ])
  return result

}
private func packages() -> [Package] {
  var result = internalPackages.map({
    Package.package(path: "\(swiftPackagesPath)/\($0)")
  })
  result.append(contentsOf: [
    Package.package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
  ])
  return result
}

private func makeInfoPList() -> InfoPlist {
  var extendedInfoPlist: [String: Plist.Value] =
  [
    "UIApplicationSceneManifest": ["UIApplicationSupportsMultipleScenes": true],
    "UILaunchScreen": [
      "UIColorName": "mainBackground",
      "UIImageName": "LaunchImage"
    ],
    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
    "UISupportedInterfaceOrientations~ipad": ["UIInterfaceOrientationPortrait"],
    "CFBundleShortVersionString": "\(version)",
    "CFBundleVersion": "\(bundleVersion)",
    "CFBundleDisplayName": "$(APP_DISPLAY_NAME)"
  ]

  return InfoPlist.extendingDefault(with: extendedInfoPlist)
}

private func makeConfigurations() -> [Configuration] {
  let debugConfiguration = Configuration.debug(name: "Debug", xcconfig: "Configs/Debug.xcconfig")
  let releaseConfiguration = Configuration.release(name: "Release", xcconfig: "Configs/Release.xcconfig")

  return [debugConfiguration, releaseConfiguration]
}

private func baseSettings() -> Settings {
  var settings = SettingsDictionary().otherSwiftFlags(["-Xfrontend -warn-long-expression-type-checking=\(msForWarningExpression)",
                                                       "-Xfrontend -warn-long-function-bodies=\(msForWarningBody)"
                                                      ])
  return Settings.settings(base: settings, configurations: [], defaultSettings: .recommended)
}

