// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCoreText",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftCoreText",
            targets: ["SwiftCoreText"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftCoreText",
            dependencies: [])
    ]
)
