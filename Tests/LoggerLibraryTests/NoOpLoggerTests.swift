//
//  NoOpLoggerTests.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

import Testing
@testable import LoggerLibrary

@Suite("NoOpLogger Tests")
struct NoOpLoggerTests {

    @Test("NoOpLogger implements Logger protocol")
    func implementsProtocol() {
        let logger: Logger = NoOpLogger()
        // Logger protocol variable can hold NoOpLogger instance
        #expect(logger is NoOpLogger)
    }

    @Test("NoOpLogger log method accepts all levels")
    func logMethodAcceptsAllLevels() {
        let logger = NoOpLogger()

        // All levels should be silently ignored - no crash = success
        logger.log(.verbose, "Test", "Verbose message")
        logger.log(.debug, "Test", "Debug message")
        logger.log(.info, "Test", "Info message")
        logger.log(.warning, "Test", "Warning message")
        logger.log(.error, "Test", "Error message")
        logger.log(.disabled, "Test", "Disabled message")
    }

    @Test("NoOpLogger convenience methods work")
    func convenienceMethods() {
        let logger = NoOpLogger()

        // All convenience methods should work without crashing
        logger.verbose("Test", "Verbose message")
        logger.debug("Test", "Debug message")
        logger.info("Test", "Info message")
        logger.warning("Test", "Warning message")
        logger.error("Test", "Error message")
    }

    @Test("NoOpLogger with autoclosure")
    func autoclosureBehavior() {
        let logger = NoOpLogger()

        // @autoclosure means the expression is wrapped in a closure automatically
        // The NoOpLogger doesn't call the closure, so expensive operations are avoided
        var expensiveComputationCalled = false

        func expensiveComputation() -> String {
            expensiveComputationCalled = true
            return "Expensive result"
        }

        // This will NOT call expensiveComputation because NoOpLogger doesn't evaluate the closure
        logger.log(.info, "Test", expensiveComputation())

        // The autoclosure is created but never executed by NoOpLogger
        #expect(expensiveComputationCalled == false)
    }

    @Test("NoOpLogger is Sendable")
    func isSendable() {
        let logger = NoOpLogger()
        // Should be safe to use across concurrency boundaries
        Task {
            logger.info("Test", "Message from Task")
        }
        // Test passes if no concurrency warnings occur
    }

    @Test("NoOpLogger can be used in arrays")
    func canBeUsedInCollections() {
        let loggers: [Logger] = [
            NoOpLogger(),
            NoOpLogger(),
            PrintLogger(logLevel: .info)
        ]

        #expect(loggers.count == 3)
        #expect(loggers[0] is NoOpLogger)
        #expect(loggers[1] is NoOpLogger)
        #expect(loggers[2] is PrintLogger)
    }

    @Test("NoOpLogger typical test usage")
    func testUsage() {
        // Typical usage in tests
        struct SomeFeature {
            let logger: Logger

            func doSomething() {
                logger.info("Feature", "Doing something")
            }
        }

        let feature = SomeFeature(logger: NoOpLogger())
        feature.doSomething()

        // Test passes without any log output - demonstrates clean test pattern
    }
}
