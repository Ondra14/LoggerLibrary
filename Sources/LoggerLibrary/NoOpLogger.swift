//
//  NoOpLogger.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

import Foundation

/// A no-operation logger that discards all log messages.
///
/// `NoOpLogger` implements the `Logger` protocol but performs no actual logging.
/// This is useful in scenarios where you need a logger instance but don't want
/// any logging output, such as in tests, production environments with logging
/// disabled, or as a placeholder in dependency injection.
///
/// ### Example of Usage:
/// ```swift
/// // Use in tests where logging output is not needed
/// let logger = NoOpLogger()
/// logger.log(.info, .app, "This message will be silently discarded")
///
/// // Use in production to disable all logging
/// let store = Store(initialState: App.State()) {
///     App()
/// } withDependencies: { dependencies in
///     dependencies.logger = NoOpLogger()
/// }
/// ```
///
/// ### Performance Note:
/// Since the `message` parameter uses `@autoclosure`, the message string is never
/// evaluated, making `NoOpLogger` extremely efficient with zero overhead for
/// message construction.
public struct NoOpLogger: Logger {
    /// Initializes a new `NoOpLogger`.
    public init() {}

    /// Logs nothing - all messages are silently discarded.
    ///
    /// - Parameters:
    ///   - level: The level of the log message (ignored).
    ///   - domain: The domain associated with the log message (ignored).
    ///   - message: The log message (never evaluated).
    public func log(_: LoggerLevel,
                    _: LoggerDomain,
                    _: @autoclosure @escaping () -> String) {
        // Intentionally empty - no logging performed
    }
}
