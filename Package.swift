// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserDefault",
    products: [
        .library(
            name: "UserDefault",
            targets: ["UserDefault"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "UserDefault",
            dependencies: []),
        .testTarget(
            name: "UserDefaultTests",
            dependencies: ["UserDefault"]),
    ]
)
