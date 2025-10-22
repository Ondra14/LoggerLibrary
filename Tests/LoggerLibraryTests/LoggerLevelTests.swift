//
//  LoggerLevelTests.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

@testable import LoggerLibrary
import Testing

@Suite("LoggerLevel Tests")
struct LoggerLevelTests {
    @Test("LoggerLevel raw values are ordered correctly")
    func rawValuesOrdering() {
        #expect(LoggerLevel.disabled.rawValue < LoggerLevel.verbose.rawValue)
        #expect(LoggerLevel.verbose.rawValue < LoggerLevel.debug.rawValue)
        #expect(LoggerLevel.debug.rawValue < LoggerLevel.info.rawValue)
        #expect(LoggerLevel.info.rawValue < LoggerLevel.warning.rawValue)
        #expect(LoggerLevel.warning.rawValue < LoggerLevel.error.rawValue)
    }

    @Test("LoggerLevel comparison operators work correctly")
    func comparisonOperators() {
        #expect(LoggerLevel.disabled < LoggerLevel.verbose)
        #expect(LoggerLevel.verbose < LoggerLevel.debug)
        #expect(LoggerLevel.debug < LoggerLevel.info)
        #expect(LoggerLevel.info < LoggerLevel.warning)
        #expect(LoggerLevel.warning < LoggerLevel.error)

        #expect(LoggerLevel.error > LoggerLevel.warning)
        #expect(LoggerLevel.warning > LoggerLevel.info)

        #expect(LoggerLevel.info == LoggerLevel.info)
    }

    @Test("LoggerLevel descriptions are correct")
    func descriptions() {
        #expect(LoggerLevel.disabled.description == "disabled")
        #expect(LoggerLevel.verbose.description == "verbose")
        #expect(LoggerLevel.debug.description == "debug")
        #expect(LoggerLevel.info.description == "info")
        #expect(LoggerLevel.warning.description == "warning")
        #expect(LoggerLevel.error.description == "error")
    }

    @Test("LoggerLevel emojis are assigned correctly")
    func emojis() {
        #expect(LoggerLevel.disabled.emoji == "🚫")
        #expect(LoggerLevel.verbose.emoji == "🔍")
        #expect(LoggerLevel.debug.emoji == "🐞")
        #expect(LoggerLevel.info.emoji == "ℹ️")
        #expect(LoggerLevel.warning.emoji == "⚠️")
        #expect(LoggerLevel.error.emoji == "❌")
    }

    @Test("LoggerLevel.defaultLevel is warning")
    func defaultLevel() {
        #expect(LoggerLevel.defaultLevel == .warning)
    }

    @Test("LoggerLevel.allCases contains all levels")
    func allCases() {
        #expect(LoggerLevel.allCases.count == 6)
        #expect(LoggerLevel.allCases.contains(.disabled))
        #expect(LoggerLevel.allCases.contains(.verbose))
        #expect(LoggerLevel.allCases.contains(.debug))
        #expect(LoggerLevel.allCases.contains(.info))
        #expect(LoggerLevel.allCases.contains(.warning))
        #expect(LoggerLevel.allCases.contains(.error))
    }
}
