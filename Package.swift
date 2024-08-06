// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Octoflows",

    platforms: [
        .iOS("13"),
    ],
    products: [
        .library(
            name: "Octoflows",
            targets: ["Octoflows"]
        ),
    ],
    targets: [
        .target(
            name: "Octoflows",
            dependencies: [],
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
    ]
)
