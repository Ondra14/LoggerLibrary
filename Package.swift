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
        // The TCA Logger client library product
        .library(
            name: "LoggerLibraryTCA",
            targets: ["LoggerLibraryTCA"])
    ],
    dependencies: [
        // Adding the Composable Architecture package dependency
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.2.0")
    ],
    targets: [
        // The main Logger library target
        .target(
            name: "LoggerLibrary",
            dependencies: []),
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
