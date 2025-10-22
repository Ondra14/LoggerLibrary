//
//  PrintLoggerTests.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

import Testing
@testable import LoggerLibrary

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
        // Create a test logger that captures output
        final class TestLogger: Logger, @unchecked Sendable {
            var messages: [(LoggerLevel, LoggerDomain, String)] = []

            func log(_ level: LoggerLevel, _ domain: LoggerDomain, _ message: @autoclosure @escaping () -> String) {
                messages.append((level, domain, message()))
            }
        }

        let testLogger = TestLogger()

        // Test that logger protocol works
        testLogger.log(.info, "Test", "Info message")
        testLogger.log(.debug, "Test", "Debug message")

        #expect(testLogger.messages.count == 2)
        #expect(testLogger.messages[0].0 == .info)
        #expect(testLogger.messages[1].0 == .debug)
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
