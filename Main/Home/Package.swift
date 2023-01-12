// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]),
        .library(
            name: "ViewComponents",
            targets: ["ViewComponents"]),
        .library(
            name: "EntityModule",
            targets: ["EntityModule"]),
        .library(
            name: "MultiPeerFeature",
            targets: ["MultiPeerFeature"]),
        .library(name: "FirebaseClient",
                 targets: ["FirebaseClient"]),
        .library(name: "WorldMapFeature",
                 targets: ["WorldMapFeature"]),
        .library(name: "CoachingOverlayFeature",
                 targets: ["CoachingOverlayFeature"]),
        .library(name: "ThumbnailGeneratorFeature",
                 targets: ["ThumbnailGeneratorFeature"]),
        .library(name: "HapticsFeature",
                 targets: ["HapticsFeature"]),
        .library(name: "MotionFeature",
                 targets: ["MotionFeature"]),
        .library(name: "UtilFeature",
                 targets: ["UtilFeature"]),
        .library(name: "SweetListFeature",
                 targets: ["SweetListFeature"]),
        .library(name: "SettingFeature",
                 targets: ["SettingFeature"]),
        .library(name: "PuttingFeature",
                 targets: ["PuttingFeature"]),
        .library(name: "SweetDetailFeature",
                 targets: ["SweetDetailFeature"]),
    ],
    dependencies: [
        .package(
            name: "Firebase",url: "https://github.com/firebase/firebase-ios-sdk.git",
                 .exactItem(.init("10.0.0")!)),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git",
                 .exactItem(.init("0.47.0")!)),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", from: "0.4.1"),
        .package(url: "https://github.com/maxxfrazer/FocusEntity.git", .exactItem(.init("2.3.0")!))
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [.product(name: "ComposableArchitecture",
                                    package: "swift-composable-architecture"),
                           .product(name: "FocusEntity",
                                    package: "FocusEntity"),
                           "CoachingOverlayFeature",
                           "SweetListFeature",
                           "SettingFeature",
                           "PuttingFeature",
                           "ViewComponents",
                           "WorldMapFeature",
                           "HapticsFeature"]),
        .target(
            name: "ViewComponents",
            dependencies: ["EntityModule"]),
        .target(
            name: "EntityModule",
            dependencies: [.product(name: "ComposableArchitecture",
                                    package: "swift-composable-architecture"),
                           "ThumbnailGeneratorFeature"]),
        .target(
            name: "MultiPeerFeature",
            dependencies: [.product(name: "ComposableArchitecture",
                                    package: "swift-composable-architecture")]),
        .target(name: "FirebaseClient",
                dependencies: [.product(name: "FirebaseFirestore",
                                        package: "Firebase"),
                               .product(name: "FirebaseStorage",
                                        package: "Firebase"),
                               .product(name: "FirebaseFirestoreSwift",
                                        package: "Firebase"),
                               "EntityModule",
                    .product(name: "ComposableArchitecture",
                             package: "swift-composable-architecture")]),
        .target(name: "WorldMapFeature",
                dependencies: [.product(name: "ComposableArchitecture",
                                        package: "swift-composable-architecture")]),
        .target(name: "CoachingOverlayFeature",
                dependencies: []),
        .target(name: "ThumbnailGeneratorFeature",
                dependencies: [.product(name: "ComposableArchitecture",
                                        package: "swift-composable-architecture")]),
        .target(name: "HapticsFeature",
                dependencies: [.product(name: "ComposableArchitecture",
                                        package: "swift-composable-architecture")]),
        .target(name: "MotionFeature",
                dependencies: [.product(name: "ComposableArchitecture",
                                        package: "swift-composable-architecture")]),
        .target(name: "UtilFeature",
                dependencies: []),
        .target(name: "SweetListFeature",
                dependencies: [.product(name: "ComposableArchitecture",
                                        package: "swift-composable-architecture"),
                               .product(name: "SwiftUINavigation",
                                        package: "swiftui-navigation"),
                               "EntityModule",
                               "SweetDetailFeature",
                               "ViewComponents",
                               "FirebaseClient"]),
        .target(name: "SettingFeature",
                dependencies: [.product(name: "ComposableArchitecture",
                                        package: "swift-composable-architecture"),
                               "EntityModule"]),
        .target(name: "PuttingFeature",
                dependencies: [.product(name: "ComposableArchitecture",
                                        package: "swift-composable-architecture")]),
        .target(name: "SweetDetailFeature",
                dependencies: [.product(name: "ComposableArchitecture",
                                                 package: "swift-composable-architecture"),
                               "EntityModule"]),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home",
                           "SweetListFeature",
                           "SettingFeature",
                           "PuttingFeature",
                           "SweetDetailFeature"]),
    ]
)
