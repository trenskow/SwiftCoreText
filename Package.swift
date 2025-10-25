// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftCoreText",
	platforms: [
		.macOS(.v10_14),
		.iOS(.v12)
	],
	products: [
		.library(
			name: "SwiftCoreText",
			targets: ["SwiftCoreText"]),
	],
	targets: [
		.target(
			name: "SwiftCoreText")
	]
)
