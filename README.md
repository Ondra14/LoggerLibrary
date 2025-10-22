<h1 align="center">LoggerLibrary</h1>

<p align="center">
A lightweight, flexible logging framework for Swift applications with support for domain-based filtering.
</p>

<p align="center">
  <a href="https://ondra14.github.io/LoggerLibrary/documentation/loggerlibrary/"><img src="https://img.shields.io/badge/docs-online-blue.svg" alt="Documentation"></a>
  <a href="https://github.com/Ondra14/LoggerLibrary/actions"><img src="https://github.com/Ondra14/LoggerLibrary/workflows/Lint,%20Build,%20and%20Test/badge.svg" alt="CI Status"></a>
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.6+-orange.svg" alt="Swift 5.6+"></a>
  <a href="https://github.com/Ondra14/LoggerLibrary/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License"></a>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#documentation">Documentation</a>
</p>

---

## Overview

<p align="center">
  <img src=".github/assets/logo.png" alt="LoggerLibrary Logo">
</p>


LoggerLibrary provides a simple yet powerful logging abstraction that enables fine-grained control over log output across different domains of your application. Whether you're building an iOS app, macOS application, or server-side Swift project, LoggerLibrary offers the flexibility to log exactly what you need, when you need it.

## Architecture & Motivation

LoggerLibrary is designed around a **protocol-first architecture** that promotes modularity and separation of concerns:

### Protocol-Only Dependencies

Your modules only depend on the `Logger` protocol—no concrete implementations. This keeps your architecture clean and your modules independent:

```swift
// In your feature module
import LoggerLibrary  // Only the protocol

struct NetworkManager {
    let logger: Logger  // Protocol dependency

    func fetchData() {
        logger.info(.network, "Fetching data...")
    }
}
```

### Domain Definition at Module Level

Each module defines its own logging domains as extensions, creating a natural namespace:

```swift
// NetworkingModule/LoggerDomain+Networking.swift
import LoggerLibrary

extension LoggerDomain {
    static let network: LoggerDomain = "Network"
    static let api: LoggerDomain = "API"
}

// DatabaseModule/LoggerDomain+Database.swift
import LoggerLibrary

extension LoggerDomain {
    static let database: LoggerDomain = "Database"
    static let persistence: LoggerDomain = "Persistence"
}
```

### Centralized Logger Configuration

Your app layer sees all domains (from imported modules) and provides the actual logger implementation with centralized control:

```swift
// App layer
import LoggerLibrary
import NetworkingModule  // Brings .network, .api domains
import DatabaseModule    // Brings .database, .persistence domains

let logger = DomainFilteredLogger(
    defaultLogLevel: .info,
    domainLogLevels: [
        // Control each module's logging independently
        .network: .debug,      // Verbose networking logs
        .api: .verbose,        // Even more detailed API logs
        .database: .info,      // Standard database logs
        .persistence: .warning // Only warnings from persistence
    ]
)

// Or create a composite logger that routes to multiple backends
struct CompositeLogger: Logger {
    let console = PrintLogger(logLevel: .debug)
    let file = FileLogger()
    let remote = RemoteLogger()

    func log(_ level: LoggerLevel, _ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
        console.log(level, domain, message())

        if level >= .error {
            file.log(level, domain, message())
            remote.log(level, domain, message())
        }
    }
}
```

### Key Benefits

- **Loose Coupling**: Modules depend only on the protocol, not concrete implementations
- **Testability**: Inject `NoOpLogger` or custom test loggers in tests
- **Flexibility**: The app decides logging strategy without changing module code
- **Scalability**: Add new modules with their own domains without conflicts
- **Type Safety**: Domain names are statically typed, preventing typos

## Features

- **Protocol-based Design**: Define custom logger implementations that conform to the `Logger` protocol
- **Domain-based Filtering**: Control log levels independently for different parts of your application
- **Multiple Logger Implementations**: Choose from built-in loggers or create your own
- **Zero-cost Abstractions**: Lazy message evaluation ensures minimal performance overhead
- **Swift Concurrency**: Full `Sendable` support for use in concurrent contexts
- **Framework Agnostic**: Works with any Swift project, from iOS apps to server-side applications
- **Optional TCA Integration**: First-class support for The Composable Architecture via the optional `LoggerLibraryTCA` module

## Installation

### Swift Package Manager

Add LoggerLibrary to your project's `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Ondra14/LoggerLibrary.git", from: "1.0.0")
]
```

Then add LoggerLibrary to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "LoggerLibrary", package: "LoggerLibrary")
    ]
)
```

**Optional:** For projects using The Composable Architecture, also add:

```swift
.product(name: "LoggerLibraryTCA", package: "LoggerLibrary")
```

## Quick Start

### Basic Logging

```swift
import LoggerLibrary

// Define your application domains
extension LoggerDomain {
    static let network: LoggerDomain = "Network"
    static let database: LoggerDomain = "Database"
    static let ui: LoggerDomain = "UI"
}

// Create a logger
let logger = PrintLogger(logLevel: .info)

// Log messages
logger.info(.network, "Fetching user data")
logger.error(.database, "Failed to save record")
logger.debug(.ui, "View did appear")
```

### Domain-Filtered Logging

Control log levels independently for different domains:

```swift
let logger = DomainFilteredLogger(
    defaultLogLevel: .warning,
    domainLogLevels: [
        .network: .debug,    // Verbose network logs
        .database: .info,    // Informational database logs
        .ui: .disabled       // No UI logs
    ]
)

logger.debug(.network, "Request headers: \(headers)")  // Logged
logger.info(.database, "Connection opened")            // Logged
logger.error(.ui, "Button tapped")                     // Not logged
```

## Available Loggers

### PrintLogger

A simple console logger with configurable log level threshold.

```swift
let logger = PrintLogger(logLevel: .info)
```

**Output format:**
```
14:23:45.123 ℹ️ [Network] Request completed successfully
```

### DomainFilteredLogger

An advanced logger that allows different log levels per domain, ideal for debugging specific subsystems.

```swift
let logger = DomainFilteredLogger(
    defaultLogLevel: .info,
    domainLogLevels: [
        .network: .debug,
        .analytics: .disabled
    ]
)
```

### NoOpLogger

A no-operation logger that discards all messages. Useful for tests or when logging should be completely disabled.

```swift
let logger = NoOpLogger()
```

## Log Levels

LoggerLibrary supports six log levels in order of increasing severity:

- `.disabled` - Logging disabled
- `.verbose` - Highly detailed tracing
- `.debug` - Debugging information
- `.info` - Informational messages
- `.warning` - Warning conditions
- `.error` - Error conditions

## TCA Integration (Optional)

For projects using The Composable Architecture, LoggerLibrary provides seamless integration through the optional `LoggerLibraryTCA` module.

```swift
import ComposableArchitecture
import LoggerLibrary
import LoggerLibraryTCA

// Use the default logger dependency
let store = Store(initialState: AppFeature.State()) {
    AppFeature()
}

// Or configure a custom logger
let store = Store(initialState: AppFeature.State()) {
    AppFeature()
} withDependencies: { dependencies in
    dependencies.logger = DomainFilteredLogger(
        defaultLogLevel: .info,
        domainLogLevels: [.network: .debug]
    )
}

// Access in your reducer
@Reducer
struct AppFeature {
    @Dependency(\.logger) var logger

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            logger.info(.ui, "App appeared")
            return .none
        }
    }
}
```

## Advanced Usage

### Creating Custom Loggers

Implement the `Logger` protocol to create custom logging backends:

```swift
import LoggerLibrary
import os.log

struct OSLogger: Logger {
    private let osLog = OSLog(subsystem: "com.example.app", category: "general")

    func log(
        _ level: LoggerLevel,
        _ domain: LoggerDomain,
        _ message: @autoclosure @escaping () -> String
    ) {
        os_log("%{public}@", log: osLog, type: level.osLogType, message())
    }
}
```

### Defining Application Domains

Create a centralized extension for your application's logging domains:

```swift
import LoggerLibrary

extension LoggerDomain {
    static let authentication: LoggerDomain = "Authentication"
    static let networking: LoggerDomain = "Networking"
    static let persistence: LoggerDomain = "Persistence"
    static let analytics: LoggerDomain = "Analytics"
    static let ui: LoggerDomain = "UI"
}
```

### Environment-Specific Configuration

Configure logging based on build configuration:

```swift
#if DEBUG
let logger = DomainFilteredLogger(
    defaultLogLevel: .debug,
    domainLogLevels: [
        .networking: .verbose,
        .analytics: .disabled
    ]
)
#else
let logger = PrintLogger(logLevel: .warning)
#endif
```

## Performance Considerations

LoggerLibrary uses `@autoclosure` for message parameters, ensuring that message strings are only evaluated when they will actually be logged:

```swift
// This expensive operation only runs if the log will be output
logger.debug(.network, "Response: \(expensiveJSONFormatting(data))")
```

This design provides zero-cost logging when messages are filtered out by log level or domain configuration.

## Documentation

📚 **[View Online Documentation](https://ondra14.github.io/LoggerLibrary/documentation/loggerlibrary/)**

Full documentation is available in the DocC bundle. Build documentation in Xcode:
**Product → Build Documentation**

Or explore the guides:
- [Getting Started Guide](Sources/LoggerLibrary/LoggerLibrary.docc/Articles/GettingStarted.md)
- [Architecture Guide](Sources/LoggerLibrary/LoggerLibrary.docc/Articles/ArchitectureGuide.md)

## Requirements

- Swift 5.6+
- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
