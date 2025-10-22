//
//  FilteredLogger.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

import Foundation

/// A logger that outputs messages to the console with per-domain log level configuration.
///
/// This logger allows you to specify different log levels for different domains,
/// giving you fine-grained control over logging output. This is particularly useful
/// when debugging specific parts of your application without being overwhelmed by
/// logs from other components.
///
/// ## Overview
///
/// `DomainFilteredLogger` extends the basic console logging functionality by allowing
/// you to configure individual log levels for each domain. Domains not specified in the
/// dictionary use the `defaultLogLevel`.
///
/// ### How It Works
///
/// 1. Each log message is associated with a domain (e.g., `.network`, `.database`)
/// 2. If the domain exists in `domainLogLevels`, that level is used (overrides default)
/// 3. If the domain is not in the dictionary, `defaultLogLevel` is used
/// 4. The message is logged only if its level meets or exceeds the domain's threshold
///
/// ## Usage Examples
///
/// ### Example 1: Debugging Network Communication
/// ```swift
/// // Define common log domains by extending `LoggerDomain`:
/// public extension LoggerDomain {
///     static let app: LoggerDomain = "App"
///     static let network: LoggerDomain = "Network"
///     static let database: LoggerDomain = "Database"
///     static let location: LoggerDomain = "Location"
/// }
///
/// // Focus on network domains while keeping other logs at info level
/// let logger = DomainFilteredLogger(
///     defaultLogLevel: .info,
///     domainLogLevels: [
///         // Detailed network debugging
///         .network: .debug,
///
///         // Suppress noisy domains
///         .location: .disabled,
///     ]
/// )
///
/// // This will be logged (debug level meets .debug threshold)
/// logger.log(.debug, .network, "Received HTTP response")
///
/// // This will be logged (info level meets .info default threshold)
/// logger.log(.info, .database, "Database opened")
///
/// // This will NOT be logged (location is disabled)
/// logger.log(.error, .location, "Failed to resolve location")
/// ```
///
/// ### Example 2: Production Configuration
/// ```swift
/// // Only log warnings and errors in production
/// let logger = DomainFilteredLogger(
///     defaultLogLevel: .warning,
///     domainLogLevels: [:] // Empty dictionary = use default for all domains
/// )
///
/// // This will NOT be logged (debug < warning threshold)
/// logger.log(.debug, .network, "Processing request")
///
/// // This WILL be logged (error >= warning threshold)
/// logger.log(.error, .database, "Connection failed")
/// ```
///
/// ### Example 3: Mixed Debug Levels
/// ```swift
/// // Different debug levels for different subsystems
/// let logger = DomainFilteredLogger(
///     defaultLogLevel: .disabled, // Disable all by default
///     domainLogLevels: [
///         .network: .debug,      // Maximum detail for network
///         .database: .info,      // Basic info for database
///         .app: .error,          // Only errors for app
///     ]
/// )
/// ```
///
/// ## Available Log Levels
///
/// - `.disabled` - No logging for this domain
/// - `.verbose` - Most detailed logging
/// - `.debug` - Detailed debug messages
/// - `.info` - Informational messages
/// - `.warning` - Warnings and errors
/// - `.error` - Only critical errors
///
/// ## Configuration in TCA
///
/// ```swift
/// let store = Store(initialState: App.State()) {
///     App()
/// } withDependencies: { dependencies in
///     dependencies.logger = DomainFilteredLogger(
///         defaultLogLevel: .info,
///         domainLogLevels: [
///             .network: .debug,
///             .database: .debug,
///         ]
///     )
/// }
/// ```
///
/// ## Performance Note
///
/// The `message` parameter uses `@autoclosure`, meaning the message string is only
/// evaluated if the log will actually be output. This ensures efficient logging even
/// with expensive string operations.
public struct DomainFilteredLogger: Logger {
    // MARK: - Properties

    /// The default log level for domains not specified in domainLogLevels.
    public var defaultLogLevel: LoggerLevel

    /// Dictionary mapping domains to their specific log levels.
    /// If a domain is not in this dictionary, defaultLogLevel is used.
    public var domainLogLevels: [LoggerDomain: LoggerLevel]

    // MARK: - Logging Method

    /// Logs a message to the console if the log level is above the threshold
    /// configured for this specific domain.
    ///
    /// - Parameters:
    ///   - level: The level of the log message.
    ///   - domain: The domain associated with the log message.
    ///   - message: The log message to be output, which is lazily evaluated.
    public func log(_ level: LoggerLevel,
                    _ domain: LoggerDomain,
                    _ message: @autoclosure @escaping () -> String) {
        // Get the log level for this domain (use default if not specified)
        let domainLogLevel = domainLogLevels[domain] ?? defaultLogLevel

        // Check if this message should be logged based on domain-specific level
        guard level != .disabled,
              domainLogLevel != .disabled, // Don't log if domain is disabled
              level >= domainLogLevel else { return }

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

    /// Initializes a new `DomainFilteredLogger` with per-domain log levels.
    ///
    /// - Parameters:
    ///   - defaultLogLevel: The default log level for domains not specified in domainLogLevels.
    ///   - domainLogLevels: Dictionary mapping domains to their specific log levels.
    ///                     If a domain has a value here, it overrides the defaultLogLevel.
    public init(defaultLogLevel: LoggerLevel, domainLogLevels: [LoggerDomain: LoggerLevel]) {
        self.defaultLogLevel = defaultLogLevel
        self.domainLogLevels = domainLogLevels
    }
}
