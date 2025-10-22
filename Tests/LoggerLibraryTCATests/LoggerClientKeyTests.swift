//
//  LoggerClientKeyTests.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

import Dependencies
@testable import LoggerLibrary
@testable import LoggerLibraryTCA
import Testing

@Suite("LoggerClientKey Tests")
struct LoggerClientKeyTests {
    @Test("LoggerKey provides liveValue")
    func liveValue() {
        let logger = LoggerKey.liveValue

        // liveValue should be printLogger
        #expect(logger is PrintLogger)

        // Verify it's the global printLogger instance
        if let printLogger = logger as? PrintLogger {
            #expect(printLogger.logLevel == .info)
        }
    }

    @Test("LoggerKey provides testValue")
    func value() {
        let logger = LoggerKey.testValue

        // testValue should be NoOpLogger for clean test output
        #expect(logger is NoOpLogger)
    }

    @Test("LoggerKey provides previewValue")
    func previewValue() {
        let logger = LoggerKey.previewValue

        // previewValue should be PrintLogger with debug level
        #expect(logger is PrintLogger)

        if let printLogger = logger as? PrintLogger {
            #expect(printLogger.logLevel == .debug)
        }
    }

    @Test("DependencyValues logger property getter in live context")
    func dependencyValuesGetter() {
        withDependencies {
            $0.context = .live
        } operation: {
            @Dependency(\.logger) var logger

            // In live context, should get liveValue (PrintLogger)
            #expect(logger is PrintLogger)
        }
    }

    @Test("DependencyValues logger property setter")
    func dependencyValuesSetter() {
        let customLogger = NoOpLogger()

        withDependencies {
            $0.logger = customLogger
        } operation: {
            @Dependency(\.logger) var logger

            #expect(logger is NoOpLogger)
        }
    }

    @Test("Logger dependency in test context")
    func testContext() {
        withDependencies {
            $0.context = .test
        } operation: {
            @Dependency(\.logger) var logger

            // In test context, should get testValue (NoOpLogger)
            #expect(logger is NoOpLogger)
        }
    }

    @Test("Logger dependency in preview context")
    func previewContext() {
        withDependencies {
            $0.context = .preview
        } operation: {
            @Dependency(\.logger) var logger

            // In preview context, should get previewValue (PrintLogger with debug)
            #expect(logger is PrintLogger)

            if let printLogger = logger as? PrintLogger {
                #expect(printLogger.logLevel == .debug)
            }
        }
    }

    @Test("Logger dependency in live context")
    func liveContext() {
        withDependencies {
            $0.context = .live
        } operation: {
            @Dependency(\.logger) var logger

            // In live context, should get liveValue (printLogger)
            #expect(logger is PrintLogger)

            if let printLogger = logger as? PrintLogger {
                #expect(printLogger.logLevel == .info)
            }
        }
    }

    @Test("Custom logger can be injected via withDependencies")
    func customLoggerInjection() {
        let customLogger = DomainFilteredLogger(
            defaultLogLevel: .error,
            domainLogLevels: ["Test": .verbose])

        withDependencies {
            $0.logger = customLogger
        } operation: {
            @Dependency(\.logger) var logger

            #expect(logger is DomainFilteredLogger)

            if let filtered = logger as? DomainFilteredLogger {
                #expect(filtered.defaultLogLevel == .error)
                #expect(filtered.domainLogLevels["Test"] == .verbose)
            }
        }
    }

    @Test("Logger dependency is isolated between contexts")
    func dependencyIsolation() {
        let logger1 = NoOpLogger()
        let logger2 = PrintLogger(logLevel: .warning)

        // Context 1
        withDependencies {
            $0.logger = logger1
        } operation: {
            @Dependency(\.logger) var contextLogger
            #expect(contextLogger is NoOpLogger)
        }

        // Context 2
        withDependencies {
            $0.logger = logger2
        } operation: {
            @Dependency(\.logger) var contextLogger
            #expect(contextLogger is PrintLogger)

            if let printLogger = contextLogger as? PrintLogger {
                #expect(printLogger.logLevel == .warning)
            }
        }
    }

    @Test("Logger can be used in typical TCA pattern")
    func tcaPattern() {
        struct TestFeature {
            @Dependency(\.logger) var logger

            func performAction() {
                logger.info("Test", "Action performed")
            }
        }

        withDependencies {
            $0.logger = NoOpLogger()
        } operation: {
            let feature = TestFeature()
            feature.performAction()

            // Test passes without log output
        }
    }
}
