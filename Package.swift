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
        // Adding the Dependencies package for dependency injection
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.0.0"),
        // Adding Swift-DocC Plugin for documentation generation
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        // The main Logger library target
        .target(
            name: "LoggerLibrary",
            dependencies: []),
        // The TCA client target that depends on both LoggerLibrary and Dependencies
        .target(
            name: "LoggerLibraryTCA",
            dependencies: [
                "LoggerLibrary",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]),
        .testTarget(
            name: "LoggerLibraryTests",
            dependencies: ["LoggerLibrary"]),
        .testTarget(
            name: "LoggerLibraryTCATests",
            dependencies: [
                "LoggerLibraryTCA",
                "LoggerLibrary",
                .product(name: "Dependencies", package: "swift-dependencies")
            ])
    ])
