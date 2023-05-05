// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.39.0")
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: [.product(name: "RealmSwift", package: "realm-swift")]),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["Services"]),
    ]
)
