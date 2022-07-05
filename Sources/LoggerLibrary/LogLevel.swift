//
//  LogLevel.swift
//
//
//  Created by Ondřej Veselý on 04.07.2022.
//

public enum LogLevel: Int, CaseIterable, Codable {
    /// Disables logging.
    case disabled
    /// log something generally unimportant (lowest priority)
    case verbose
    /// log something which help during debugging (low priority)
    case debug
    /// log something which you are really interested but which is not an issue or error (normal priority)
    case info
    /// log something which may cause big trouble soon (high priority)
    case warning
    /// log something which will keep you awake at night (highest priority)
    case error

    static let defaultLevel = LogLevel.warning
}

extension LogLevel: CustomStringConvertible {
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

extension LogLevel: Comparable {
    /// Compares levels by severity.
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: `true` if left operand has lower severity than right operand.
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
