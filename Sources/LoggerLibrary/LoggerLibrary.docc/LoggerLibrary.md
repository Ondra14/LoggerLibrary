# ``LoggerLibrary``

@Metadata {
    @DisplayName("LoggerLibrary")
}

A lightweight, flexible logging framework with domain-based filtering for Swift applications.

## Overview

LoggerLibrary provides a protocol-based logging abstraction that enables fine-grained control over log output across different domains of your application. The framework is designed to be framework-agnostic, working seamlessly with any Swift project.

### Key Features

- **Protocol-based Design**: Depend only on the `Logger` protocol, not concrete implementations
- **Domain-based Filtering**: Control log levels independently for different parts of your application
- **Multiple Logger Implementations**: Built-in loggers for console output, filtering, and no-op scenarios
- **Zero-cost Abstractions**: Lazy message evaluation ensures minimal performance overhead
- **Swift Concurrency**: Full `Sendable` support for concurrent contexts

## Topics

### Essentials

- <doc:GettingStarted>
- ``Logger``
- ``LoggerLevel``
- ``LoggerDomain``

### Logger Implementations

- ``PrintLogger``
- ``DomainFilteredLogger``
- ``NoOpLogger``

### Architecture

- <doc:ArchitectureGuide>
