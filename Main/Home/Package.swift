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
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: []),
        .target(
            name: "Repositry",
            dependencies: []),
        .target(
            name: "ViewComponents",
            dependencies: []),
        .target(
            name: "DomainModule",
            dependencies: []),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]),
    ]
)
