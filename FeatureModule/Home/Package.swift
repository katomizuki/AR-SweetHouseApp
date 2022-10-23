// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Home"),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]),
    ]
)
