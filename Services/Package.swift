// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: []),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["Services"]),
    ]
)
