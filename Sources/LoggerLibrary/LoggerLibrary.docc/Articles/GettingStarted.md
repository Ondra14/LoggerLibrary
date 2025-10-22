# Getting Started with LoggerLibrary

@Metadata {
    @PageKind(sampleCode)
    @PageColor(orange)
}

Learn how to integrate LoggerLibrary into your Swift project and start logging.

## Overview

![LoggerLibrary](logo.png)

This guide walks you through the basics of using LoggerLibrary in your application, from defining domains to choosing the right logger implementation.

## Define Your Logging Domains

Start by defining the logging domains for your application. Each domain represents a distinct area or subsystem:

```swift
import LoggerLibrary

extension LoggerDomain {
    static let network: LoggerDomain = "Network"
    static let database: LoggerDomain = "Database"
    static let ui: LoggerDomain = "UI"
}
```

> Tip: Define domains in each module as extensions, allowing the app layer to see all domains and configure logging centrally.

## Choose a Logger

LoggerLibrary provides three built-in logger implementations:

### PrintLogger

Simple console logging with a single log level threshold:

```swift
let logger = PrintLogger(logLevel: .info)

logger.info(.network, "Request started")
logger.debug(.network, "This won't be logged (below .info threshold)")
```

### DomainFilteredLogger

Advanced logging with per-domain log level control:

```swift
let logger = DomainFilteredLogger(
    defaultLogLevel: .warning,
    domainLogLevels: [
        .network: .debug,    // Verbose network logs
        .database: .info,    // Standard database logs
        .ui: .disabled       // No UI logs
    ]
)

logger.debug(.network, "Request headers: \(headers)")  // Logged
logger.info(.database, "Query executed")               // Logged
logger.error(.ui, "View error")                        // Not logged (disabled)
```

### NoOpLogger

Discards all log messages, useful for tests:

```swift
let logger = NoOpLogger()

logger.error(.network, "This will be silently discarded")
```

## Log Messages

Use convenience methods for common log levels:

```swift
logger.verbose(.network, "Detailed trace information")
logger.debug(.network, "Debugging information")
logger.info(.network, "General information")
logger.warning(.network, "Warning condition")
logger.error(.network, "Error occurred")
```

Or use the core `log(_:_:_:)` method directly:

```swift
logger.log(.info, .network, "Custom log message")
```

## Lazy Evaluation

Message strings use `@autoclosure`, ensuring they're only evaluated when logged:

```swift
// This expensive operation only runs if the log will be output
logger.debug(.network, "Response: \(expensiveJSONFormatting(data))")
```

## Module-Level Architecture

For modular applications, each module should:

1. Import only `LoggerLibrary` (the protocol)
2. Define its own logging domains
3. Accept a `Logger` as a dependency

```swift
// In NetworkingModule
import LoggerLibrary

extension LoggerDomain {
    static let network: LoggerDomain = "Network"
}

struct NetworkManager {
    let logger: Logger

    func fetchData() {
        logger.info(.network, "Fetching data...")
    }
}
```

The app layer provides the concrete logger implementation:

```swift
// In App
import LoggerLibrary
import NetworkingModule

let logger = DomainFilteredLogger(
    defaultLogLevel: .info,
    domainLogLevels: [.network: .debug]
)

let networkManager = NetworkManager(logger: logger)
```

## Next Steps

- Explore <doc:ArchitectureGuide> for advanced patterns
- Learn about creating custom loggers by conforming to ``Logger``
- See ``DomainFilteredLogger`` for fine-grained control
