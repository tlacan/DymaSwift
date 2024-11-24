import ProjectDescription

let project = Project(
    name: "newTuist",
    targets: [
        .target(
            name: "newTuist",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.newTuist",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["newTuist/Sources/**"],
            resources: ["newTuist/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "newTuistTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.newTuistTests",
            infoPlist: .default,
            sources: ["newTuist/Tests/**"],
            resources: [],
            dependencies: [.target(name: "newTuist")]
        ),
    ]
)
