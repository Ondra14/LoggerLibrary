//
//  Logger.swift
//
//
//  Created by Ondřej Veselý on 04.07.2022.
//

public protocol Logger {
    func setup(logLevel: LogLevel)
    func log<Category: CustomStringConvertible>(_ level: LogLevel, _ category: Category, _ message: @autoclosure () -> String)
}

public extension Logger {
    func debug<Category: CustomStringConvertible>(_ category: Category, _ message: @autoclosure () -> String) {
        log(.debug, category, message())
    }

    func verbose<Category: CustomStringConvertible>(_ category: Category, _ message: @autoclosure () -> String) {
        log(.verbose, category, message())
    }

    func info<Category: CustomStringConvertible>(_ category: Category, _ message: @autoclosure () -> String) {
        log(.info, category, message())
    }

    func warning<Category: CustomStringConvertible>(_ category: Category, _ message: @autoclosure () -> String) {
        log(.warning, category, message())
    }

    func error<Category: CustomStringConvertible>(_ category: Category, _ message: @autoclosure () -> String) {
        log(.error, category, message())
    }
}
