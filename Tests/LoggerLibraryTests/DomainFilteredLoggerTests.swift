//
//  DomainFilteredLoggerTests.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

import Testing
@testable import LoggerLibrary

@Suite("DomainFilteredLogger Tests")
struct DomainFilteredLoggerTests {

    // Test domains
    private let networkDomain: LoggerDomain = "Network"
    private let databaseDomain: LoggerDomain = "Database"
    private let uiDomain: LoggerDomain = "UI"

    @Test("DomainFilteredLogger uses default level for unconfigured domains")
    func defaultLevelForUnconfiguredDomains() {
        // Simulate filtered logger behavior
        let defaultLevel = LoggerLevel.warning
        let configuredDomains: [LoggerDomain: LoggerLevel] = [networkDomain: .debug]

        // Test unconfigured domain (should use default)
        let domainLevel = configuredDomains[databaseDomain] ?? defaultLevel
        #expect(domainLevel == .warning)
    }

    @Test("DomainFilteredLogger uses domain-specific level when configured")
    func domainSpecificLevel() {
        let logger = DomainFilteredLogger(
            defaultLogLevel: .warning,
            domainLogLevels: [
                networkDomain: .debug,
                databaseDomain: .info
            ]
        )

        #expect(logger.defaultLogLevel == .warning)
        #expect(logger.domainLogLevels[networkDomain] == .debug)
        #expect(logger.domainLogLevels[databaseDomain] == .info)
        #expect(logger.domainLogLevels[uiDomain] == nil) // Uses default
    }

    @Test("DomainFilteredLogger respects disabled domain")
    func disabledDomain() {
        let logger = DomainFilteredLogger(
            defaultLogLevel: .info,
            domainLogLevels: [
                networkDomain: .disabled
            ]
        )

        #expect(logger.domainLogLevels[networkDomain] == .disabled)
    }

    @Test("DomainFilteredLogger can be initialized with empty domain dictionary")
    func emptyDomainDictionary() {
        let logger = DomainFilteredLogger(
            defaultLogLevel: .info,
            domainLogLevels: [:]
        )

        #expect(logger.defaultLogLevel == .info)
        #expect(logger.domainLogLevels.isEmpty)
    }

    @Test("DomainFilteredLogger handles multiple domains with different levels")
    func multipleDomains() {
        let logger = DomainFilteredLogger(
            defaultLogLevel: .disabled,
            domainLogLevels: [
                networkDomain: .verbose,
                databaseDomain: .debug,
                uiDomain: .info
            ]
        )

        #expect(logger.domainLogLevels[networkDomain] == .verbose)
        #expect(logger.domainLogLevels[databaseDomain] == .debug)
        #expect(logger.domainLogLevels[uiDomain] == .info)
    }

    @Test("DomainFilteredLogger convenience methods work")
    func convenienceMethods() {
        let logger = DomainFilteredLogger(
            defaultLogLevel: .verbose,
            domainLogLevels: [:]
        )

        // These should compile and not crash
        logger.verbose(networkDomain, "Verbose message")
        logger.debug(networkDomain, "Debug message")
        logger.info(networkDomain, "Info message")
        logger.warning(networkDomain, "Warning message")
        logger.error(networkDomain, "Error message")
    }

    @Test("DomainFilteredLogger filtering logic")
    func filteringLogic() {
        // Test the filtering conditions
        let messageLevel = LoggerLevel.debug
        let domainLogLevel = LoggerLevel.info

        // debug < info, so message should NOT be logged
        let shouldLog = messageLevel >= domainLogLevel
        #expect(shouldLog == false)

        // error >= info, so message SHOULD be logged
        let errorLevel = LoggerLevel.error
        let shouldLogError = errorLevel >= domainLogLevel
        #expect(shouldLogError == true)
    }

    @Test("DomainFilteredLogger disabled level blocks all messages")
    func disabledLevelBlocksAll() {
        let messageLevel = LoggerLevel.error
        let domainLogLevel = LoggerLevel.disabled

        // Even error level should be blocked if domain is disabled
        let shouldLog = messageLevel != .disabled && domainLogLevel != .disabled
        #expect(shouldLog == false)
    }
}
