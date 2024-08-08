// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Onboardings",

    platforms: [
        .iOS("13"),
    ],
    products: [
        .library(
            name: "Onboardings",
            targets: ["Onboardings"]
        ),
    ],
    targets: [
        .target(
            name: "Onboardings",
            dependencies: [],
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
    ]
)
