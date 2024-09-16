// swift-tools-version: 5.6
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
            targets: ["SwiftLogAdapterLibrary"]),
        // The TCA Logger client library product
        .library(
            name: "LoggerLibraryTCA",
            targets: ["LoggerLibraryTCA"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        // Adding the swift-log package dependency
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
        // Adding the Composable Architecture package dependency
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.2.0")
    ],
    targets: [
        // The main Logger library target
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
        // The TCA client target that depends on both LoggerLibrary and Composable Architecture
        .target(
            name: "LoggerLibraryTCA",
            dependencies: [
                "LoggerLibrary",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .testTarget(
            name: "LoggerLibraryTests",
            dependencies: ["LoggerLibrary"])
    ])
