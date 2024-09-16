//
//  TCAClientLogger.swift
//
//
//  Created by Ondřej Veselý on 16.09.2024.
//

import ComposableArchitecture
import LoggerLibrary

@DependencyClient
public struct LoggerClient {
    public var log: (LoggerLevel, LoggerDomain, () -> String)
}

public enum LoggerClientKey: DependencyKey {
    /// The default implementation of the logger dependency.
    /// This uses `printLogger`, which outputs messages to the console with a configurable log level.
    public static var liveValue: Logger {
        printLogger
    }
}

public extension DependencyValues {
    var logger: Logger {
        get {
            self[LoggerClientKey.self]
        }

        set {
            self[LoggerClientKey.self] = newValue
        }
    }
}
