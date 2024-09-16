//
//  PrintLogger.swift
//
//
//  Created by Ondřej Veselý on 16.09.2024.
//

import Foundation
import LoggerLibrary

/// A simple logger that prints log messages to the console using the `print` function.
public let printLogger = PrintLogger(logLevel: .info)

/// A logger that outputs messages to the console.
///
/// The `PrintLogger` uses a configurable log level to control which messages are logged
/// and formats messages with a timestamp. It is designed for simple console logging
/// where messages are printed to standard output.
///
/// ### Example of Usage:
/// ```swift
/// // Define common log domains by extending `LoggerDomain`:
/// public extension LoggerDomain {
///     static let app: LoggerDomain = "App"
///     static let network: LoggerDomain = "Network"
///     static let database: LoggerDomain = "Database"
/// }
///
/// // Create a logger instance with a specified log level
/// let logger = PrintLogger(logLevel: .info)
///
/// // Log messages at different levels using predefined domains
/// logger.log(.info, .app, "Application started.")
/// logger.log(.debug, .network, "Fetching data from the server.")
/// logger.log(.error, .database, "Failed to save record.")
/// ```
public struct PrintLogger: Logger {
    // MARK: - Properties

    /// The minimum log level for messages to be logged.
    var logLevel = LoggerLevel.info

    // MARK: - Logging Method

    /// Logs a message to the console if the log level is above the configured threshold.
    ///
    /// - Parameters:
    ///   - level: The level of the log message.
    ///   - domain: The domain associated with the log message.
    ///   - message: The log message to be output, which is lazily evaluated.
    public func log(_ level: LoggerLibrary.LoggerLevel,
                    _ domain: LoggerLibrary.LoggerDomain,
                    _ message: @autoclosure @escaping () -> String) {
        guard level != .disabled,
              level >= logLevel else { return }
        let date = Self.defaultDateFormatter.string(from: Date())
        print("\(date) \(level.emoji) [\(domain.description)]", message())
    }

    // MARK: - Date Formatter

    /// The default date formatter for log timestamps.
    static let defaultDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter
    }()

    // MARK: - Initializer

    /// Initializes a new `PrintLogger` with the specified log level.
    ///
    /// - Parameter logLevel: The minimum log level for messages to be logged.
    public init(logLevel: LoggerLevel) {
        self.logLevel = logLevel
    }
}
