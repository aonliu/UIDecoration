// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIDecoration",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "UIDecoration",
            targets: ["UIDecoration"]
        )
    ],
    targets: [
        .target(
            name: "UIDecoration",
            path: "UIDecoration"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
