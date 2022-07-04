//
//  Logger.swift
//
//
//  Created by Ondřej Veselý on 04.07.2022.
//
public protocol Logger {
    associatedtype Category: CustomStringConvertible
    func setup(logLevel: LogLevel)
    func log(_ level: LogLevel, _ message: @autoclosure () -> String)
}

public extension Logger {
    func debug(_ message: @autoclosure () -> String) {
        log(.debug, message())
    }

    func verbose(_ message: @autoclosure () -> String) {
        log(.verbose, message())
    }

    func info(_ message: @autoclosure () -> String) {
        log(.info, message())
    }

    func warning(_ message: @autoclosure () -> String) {
        log(.warning, message())
    }

    func error(_ message: @autoclosure () -> String) {
        log(.error, message())
    }
}
