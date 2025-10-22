//
//  LoggerClientKey.swift
//
//
//  Created by Ondřej Veselý on 16.09.2024.
//

import Dependencies
import LoggerLibrary

public enum LoggerKey: DependencyKey {
    /// The live implementation of the logger dependency.
    /// Uses `printLogger` which outputs messages to the console with a configurable log level.
    public static var liveValue: Logger {
        printLogger
    }

    /// The test implementation of the logger dependency.
    /// Uses `NoOpLogger` which discards all log messages for clean test output.
    public static var testValue: Logger {
        NoOpLogger()
    }

    /// The preview implementation of the logger dependency.
    /// Uses `PrintLogger` with debug level for detailed preview logging.
    public static var previewValue: Logger {
        PrintLogger(logLevel: .debug)
    }
}

public extension DependencyValues {
    var logger: Logger {
        get {
            self[LoggerKey.self]
        }

        set {
            self[LoggerKey.self] = newValue
        }
    }
}
