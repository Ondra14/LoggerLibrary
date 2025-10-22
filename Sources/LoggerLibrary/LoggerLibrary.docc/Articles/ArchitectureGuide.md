# Architecture Guide

@Metadata {
    @PageColor(blue)
}

Understand the protocol-first architecture and how to structure logging in modular applications.

## Overview

LoggerLibrary is designed around a protocol-first architecture that promotes loose coupling, testability, and flexibility. This guide explains the architectural patterns and best practices.

## Protocol-First Design

### Depend on Abstractions

Your modules should depend only on the ``Logger`` protocol, never on concrete implementations:

```swift
// ✅ Good: Protocol dependency
import LoggerLibrary

struct FeatureManager {
    let logger: Logger  // Protocol type
}

// ❌ Bad: Concrete dependency
import LoggerLibrary

struct FeatureManager {
    let logger: PrintLogger  // Concrete type
}
```

This keeps your modules independent and testable.

## Domain Organization

### Module-Level Domains

Each module defines its own logging domains as extensions to ``LoggerDomain``:

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

### Benefits

- **Natural Namespacing**: Domains are scoped to their modules
- **Type Safety**: Static properties prevent typos
- **Discoverability**: Xcode autocomplete shows available domains
- **No Conflicts**: Multiple modules can safely define domains

## Centralized Configuration

The app layer imports all modules and sees all their domains, enabling centralized logger configuration:

```swift
// App layer
import LoggerLibrary
import NetworkingModule  // Brings .network, .api
import DatabaseModule    // Brings .database, .persistence

let logger = DomainFilteredLogger(
    defaultLogLevel: .info,
    domainLogLevels: [
        // Control each module independently
        .network: .debug,
        .api: .verbose,
        .database: .info,
        .persistence: .warning
    ]
)
```

This pattern allows you to:

- Debug specific subsystems without noise from others
- Configure logging per environment (debug vs. release)
- Change logging strategy without modifying module code

## Custom Logger Implementations

### Single-Backend Logger

Create loggers for specific backends:

```swift
import os.log

struct OSLogger: Logger {
    private let osLog = OSLog(subsystem: "com.app", category: "general")

    func log(
        _ level: LoggerLevel,
        _ domain: LoggerDomain,
        _ message: @autoclosure @escaping () -> String
    ) {
        let type: OSLogType = switch level {
        case .verbose, .debug: .debug
        case .info: .info
        case .warning, .error: .error
        case .disabled: .default
        }
        os_log("%{public}@", log: osLog, type: type, message())
    }
}
```

### Composite Logger

Combine multiple loggers with custom routing logic:

```swift
struct CompositeLogger: Logger {
    let console = PrintLogger(logLevel: .debug)
    let file = FileLogger()
    let remote = RemoteLogger()

    func log(
        _ level: LoggerLevel,
        _ domain: LoggerDomain,
        _ message: @autoclosure @escaping () -> String
    ) {
        // Always log to console
        console.log(level, domain, message())

        // Log errors to file and remote service
        if level >= .error {
            file.log(level, domain, message())
            remote.log(level, domain, message())
        }
    }
}
```

### Domain-Specific Router

Route different domains to different backends:

```swift
struct RouterLogger: Logger {
    let analyticsLogger = AnalyticsLogger()
    let consoleLogger = PrintLogger(logLevel: .debug)

    func log(
        _ level: LoggerLevel,
        _ domain: LoggerDomain,
        _ message: @autoclosure @escaping () -> String
    ) {
        switch domain.description {
        case "Analytics":
            analyticsLogger.log(level, domain, message())
        default:
            consoleLogger.log(level, domain, message())
        }
    }
}
```

## Testing Strategies

### Use NoOpLogger in Tests

The ``NoOpLogger`` discards all messages, keeping test output clean:

```swift
func testNetworkRequest() {
    let logger = NoOpLogger()
    let manager = NetworkManager(logger: logger)

    // Test without log noise
    manager.fetchData()
}
```

### Verify Logging Behavior

Create a test logger to verify log calls:

```swift
final class TestLogger: Logger {
    var messages: [(LoggerLevel, LoggerDomain, String)] = []

    func log(
        _ level: LoggerLevel,
        _ domain: LoggerDomain,
        _ message: @autoclosure @escaping () -> String
    ) {
        messages.append((level, domain, message()))
    }
}

func testLogsError() {
    let testLogger = TestLogger()
    let manager = NetworkManager(logger: testLogger)

    manager.handleError()

    XCTAssertEqual(testLogger.messages.count, 1)
    XCTAssertEqual(testLogger.messages[0].0, .error)
}
```

## Environment Configuration

Configure logging based on build configuration:

```swift
#if DEBUG
let logger = DomainFilteredLogger(
    defaultLogLevel: .debug,
    domainLogLevels: [
        .network: .verbose,
        .analytics: .disabled
    ]
)
#else
let logger = PrintLogger(logLevel: .warning)
#endif
```

Or use environment variables:

```swift
let logLevel: LoggerLevel = ProcessInfo.processInfo.environment["LOG_LEVEL"]
    .flatMap(LoggerLevel.init(rawValue:)) ?? .info

let logger = PrintLogger(logLevel: logLevel)
```

## Best Practices

### Do

- ✅ Depend on the ``Logger`` protocol in modules
- ✅ Define domains as static properties on ``LoggerDomain``
- ✅ Use ``DomainFilteredLogger`` for flexible debugging
- ✅ Use ``NoOpLogger`` in tests
- ✅ Configure logger at the app layer

### Don't

- ❌ Import concrete logger types in modules
- ❌ Use string literals for domains
- ❌ Create logger instances in module code
- ❌ Log sensitive information (passwords, tokens)

## Performance Considerations

LoggerLibrary uses `@autoclosure` for message parameters, ensuring zero-cost when messages are filtered:

```swift
// This expensive operation only runs if logged
logger.debug(.network, "Data: \(expensiveFormatting(data))")

// If .network is disabled or level < .debug, the closure never executes
```

This makes it safe to include detailed debug logging without performance impact in production.
