// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "stability.ai-api",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "stability.ai-api",
            targets: ["stability.ai-api"]),
    ],
    targets: [
        .target(
            name: "stability.ai-api"),
    ]
)
