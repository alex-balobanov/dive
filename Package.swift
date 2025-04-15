// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DIve",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
        .tvOS(.v17)
    ],
    products: [
        .library(name: "DIve", targets: ["DIve"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "DIve", dependencies: []),
        .testTarget(name: "DIveTests", dependencies: ["DIve"]),
    ]
)
