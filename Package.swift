// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "stabilityai-kit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "StabilityAIKit",
            targets: ["StabilityAIKit"]),
    ],
    targets: [
        .target(
            name: "StabilityAIKit"),
    ]
)
