//
//  Logger.swift
//
//
//  Created by Ondřej Veselý on 20.01.2023.
//

/// An protocol for writing interpolated string messages to the unified logging system.
/// corresponding to a log level.
public protocol Logger: Sendable {
    /// Writes a message to the log.
    func log(_ level: LoggerLevel, _ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String)
}

public extension Logger {
    /// Writes a debug message to the log.
    func debug(_ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
        log(.debug, domain, message())
    }

    /// Writes a message to the log using the default log type.
    func verbose(_ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
        log(.verbose, domain, message())
    }

    /// Writes an informative message to the log.
    func info(_ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
        log(.info, domain, message())
    }

    /// Writes information about a warning to the log.
    func warning(_ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
        log(.warning, domain, message())
    }

    /// Writes information about an error to the log.
    func error(_ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
        log(.error, domain, message())
    }
}
