// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "simproktools",
    products: [
        .library(
            name: "simproktools",
            targets: ["simproktools"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/simprok-dev/simprokmachine-ios.git",
            exact: .init(1, 1, 8)
        ),
    ],
    targets: [
        .target(
            name: "simproktools",
            dependencies: [
                .product(
                    name: "simprokmachine",
                    package: "simprokmachine"
                )
            ]
        )
    ]
)
