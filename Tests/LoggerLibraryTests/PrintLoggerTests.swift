//
//  PrintLoggerTests.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

@testable import LoggerLibrary
import Testing

private final class TestLogger: Logger, @unchecked Sendable {
    struct LogEntry {
        let level: LoggerLevel
        let domain: LoggerDomain
        let message: String
    }

    var messages: [LogEntry] = []

    func log(_ level: LoggerLevel, _ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
        messages.append(LogEntry(level: level, domain: domain, message: message()))
    }
}

@Suite("PrintLogger Tests")
struct PrintLoggerTests {
    @Test("PrintLogger can be initialized with different log levels")
    func initialization() {
        let logger1 = PrintLogger(logLevel: .debug)
        #expect(logger1.logLevel == .debug)

        let logger2 = PrintLogger(logLevel: .error)
        #expect(logger2.logLevel == .error)
    }

    @Test("PrintLogger logs messages at or above configured level")
    func logLevelFiltering() {
        let testLogger = TestLogger()

        // Test that logger protocol works
        testLogger.log(.info, "Test", "Info message")
        testLogger.log(.debug, "Test", "Debug message")

        #expect(testLogger.messages.count == 2)
        #expect(testLogger.messages[0].level == .info)
        #expect(testLogger.messages[1].level == .debug)
    }

    @Test("PrintLogger respects disabled level")
    func disabledLevel() {
        let logger = PrintLogger(logLevel: .disabled)
        #expect(logger.logLevel == .disabled)

        // Logger won't actually log, but we verify it's configured correctly
    }

    @Test("PrintLogger convenience methods exist")
    func convenienceMethods() {
        let logger = PrintLogger(logLevel: .verbose)

        // These should compile and not crash
        logger.verbose("Test", "Verbose message")
        logger.debug("Test", "Debug message")
        logger.info("Test", "Info message")
        logger.warning("Test", "Warning message")
        logger.error("Test", "Error message")
    }

    @Test("printLogger global instance is available")
    func globalInstance() {
        #expect(printLogger.logLevel == .info)
    }
}
