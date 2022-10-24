// swift-tools-version: 5.5
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
        .package(url:"https://github.com/pointfreeco/swift-composable-architecture.git",
                 from: "0.43.0")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: "ComposableArchitecture",
                         package:"swift-composable-architecture"),
            ]),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]),
    ]
)
