// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "simproktools",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "simproktools",
            targets: ["simproktools"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/simprok-dev/simprokstate-ios.git",
            exact: .init(1, 2, 36)
        ),
    ],
    targets: [
        .target(
            name: "simproktools",
            dependencies: [
                .product(
                    name: "simprokstate",
                    package: "simprokstate-ios"
                )
            ]
        )
    ]
)
