// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggerLibrary",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .macOS(.v10_15), .watchOS(.v6)
    ],
    products: [
        // The main Logger library product
        .library(
            name: "LoggerLibrary",
            targets: ["LoggerLibrary"]),
        // The SwiftLogAdapter library product that integrates with Apple's Swift Logging API
        .library(
            name: "SwiftLogAdapterLibrary",
            targets: ["SwiftLogAdapterLibrary"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        // Adding the swift-log package dependency
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LoggerLibrary",
            dependencies: []),
        // The SwiftLogAdapter library target that depends on both LoggerLibrary and swift-log
        .target(
            name: "SwiftLogAdapterLibrary",
            dependencies: [
                "LoggerLibrary",
                .product(name: "Logging", package: "swift-log")
            ]),
        .testTarget(
            name: "LoggerLibraryTests",
            dependencies: ["LoggerLibrary"])
    ])
