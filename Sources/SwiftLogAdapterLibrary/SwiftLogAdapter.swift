//
//  SwiftLogAdapter.swift
//
//
//  Created by Ondřej Veselý on 16.09.2024.
//

import LoggerLibrary // Import the base Logger library
import Logging // Import Apple's Swift Logging API

public class SwiftLogAdapter: LoggerLibrary.Logger {
    private var logger: Logging.Logger
    private var levels: [LoggerDomain: LoggerLevel] = [:]
    private var globalLevel: LoggerLevel = .defaultLevel

    public init(label: String) {
        self.logger = Logger(label: label)
        logger.logLevel = Logger.Level.trace
    }

    public func log(_ level: LoggerLevel, _ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
        let currentLevel = levels[domain] ?? globalLevel
        guard level.rawValue >= currentLevel.rawValue else { return }

        switch level {
        case .verbose:
            logger.trace("\(domain): \(message())")
        case .debug:
            logger.debug("\(domain): \(message())")
        case .info:
            logger.info("\(domain): \(message())")
        case .warning:
            logger.warning("\(domain): \(message())")
        case .error:
            logger.error("\(domain): \(message())")
        default:
            break
        }
    }

    public func set(level: LoggerLevel, for domain: LoggerDomain?) {
        if let domain = domain {
            levels[domain] = level
        } else {
            globalLevel = level
        }
    }

    public func resetLevels() {
        levels.removeAll()
        globalLevel = .defaultLevel
    }
}
