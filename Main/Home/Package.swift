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
        .library(
            name: "Repositry",
            targets: ["Repositry"]),
        .library(
            name: "ViewComponents",
            targets: ["ViewComponents"]),
        .library(
            name: "DomainModule",
            targets: ["DomainModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git",
                 .exactItem(.init("10.0.0")!)),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git",
                 .exactItem(.init("0.45.0")!))
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [.product(name: "ComposableArchitecture",
                                    package: "swift-composable-architecture")]),
        .target(
            name: "Repositry",
            dependencies: [.product(name: "ComposableArchitecture",
                                    package: "swift-composable-architecture")]),
        .target(
            name: "ViewComponents",
            dependencies: []),
        .target(
            name: "DomainModule",
            dependencies: [.product(name: "ComposableArchitecture",
                                    package: "swift-composable-architecture")]),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]),
    ]
)
