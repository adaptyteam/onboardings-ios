// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Onbordings",

    platforms: [
        .iOS("13"),
    ],
    products: [
        .library(
            name: "Onbordings",
            targets: ["Onbordings"]
        ),
    ],
    targets: [
        .target(
            name: "Onbordings",
            dependencies: [],
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
    ]
)
