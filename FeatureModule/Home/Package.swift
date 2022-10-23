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
        .package(url:"https://github.com/pointfreeco/swift-composable-architecture.git" ,
                 .upToNextMajor(from: "0.9.0"))
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
