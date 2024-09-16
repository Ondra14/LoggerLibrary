//
//  LoggerLevel.swift
//
//
//  Created by Ondřej Veselý on 20.01.2023.
//

/// An enumeration representing the various levels of logging supported by a logger instance.
///
/// Each case of the enumeration corresponds to a specific logging level, with `disabled` representing the lowest level of logging and `error` representing the highest level.
///
/// - Note: This enumeration conforms to the `Int`, `CaseIterable` protocols, allowing it to be used in a variety of contexts.
public enum LoggerLevel: Int, CaseIterable, Sendable {
    /// The `disabled` logging level, indicating that no logging should be performed.
    case disabled

    /// The `verbose` logging level, providing the most detailed logging output.
    case verbose

    /// The `debug` logging level, providing detailed logging output for debugging purposes.
    case debug

    /// The `info` logging level, providing general information about the application's state.
    case info

    /// The `warning` logging level, indicating potential issues or areas of concern.
    case warning

    /// The `error` logging level, indicating a critical error that requires attention.
    case error

    /// The default logging level, used when a specific level is not specified.
    public static let defaultLevel = LoggerLevel.warning
}

extension LoggerLevel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .disabled:
            return "disabled"
        case .verbose:
            return "verbose"
        case .debug:
            return "debug"
        case .info:
            return "info"
        case .warning:
            return "warning"
        case .error:
            return "error"
        }
    }
}

extension LoggerLevel: Comparable {
    /// Compares levels by severity.
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: `true` if left operand has lower severity than right operand.
    public static func < (lhs: LoggerLevel, rhs: LoggerLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
