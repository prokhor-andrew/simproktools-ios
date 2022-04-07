// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "simproktools",
    platforms: [ .iOS(.v11) ],
    products: [
        .library(
            name: "simproktools",
            targets: ["simproktools"]
        ),
    ],
    dependencies: [
        .package(
            name: "simprokmachine",
            url: "https://github.com/simprok-dev/simprokmachine-ios.git",
            from: .init(1, 1, 1)
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
