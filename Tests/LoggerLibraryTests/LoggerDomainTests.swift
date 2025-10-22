//
//  LoggerDomainTests.swift
//
//
//  Created by Ondřej Veselý on 22.10.2025.
//

@testable import LoggerLibrary
import Testing

@Suite("LoggerDomain Tests")
struct LoggerDomainTests {
    @Test("LoggerDomain can be created with string literal")
    func stringLiteralInitialization() {
        let domain: LoggerDomain = "Network"
        #expect(domain.description == "Network")
    }

    @Test("LoggerDomain can be created with init(_:)")
    func explicitInitialization() {
        let domain1 = LoggerDomain("Database")
        #expect(domain1.description == "Database")

        // Test with various strings
        let domain2 = LoggerDomain("Network")
        #expect(domain2.description == "Network")

        let domain3 = LoggerDomain("UI-Components")
        #expect(domain3.description == "UI-Components")

        // Test equality between init(_:) and string literal
        let domainA = LoggerDomain("Test")
        let domainB: LoggerDomain = "Test"
        #expect(domainA == domainB)
    }

    @Test("LoggerDomain description property works")
    func descriptionProperty() {
        let domain: LoggerDomain = "UI"
        #expect(domain.description == "UI")
    }

    @Test("LoggerDomain equality works")
    func equality() {
        let domain1: LoggerDomain = "Network"
        let domain2: LoggerDomain = "Network"
        let domain3: LoggerDomain = "Database"

        #expect(domain1 == domain2)
        #expect(domain1 != domain3)
    }

    @Test("LoggerDomain is hashable")
    func hashable() {
        let domain1: LoggerDomain = "Network"
        let domain2: LoggerDomain = "Network"
        let domain3: LoggerDomain = "Database"

        #expect(domain1.hashValue == domain2.hashValue)
        #expect(domain1.hashValue != domain3.hashValue)
    }

    @Test("LoggerDomain can be used as Dictionary key")
    func dictionaryKey() {
        var domainLevels: [LoggerDomain: LoggerLevel] = [:]

        let networkDomain: LoggerDomain = "Network"
        let databaseDomain: LoggerDomain = "Database"

        domainLevels[networkDomain] = .debug
        domainLevels[databaseDomain] = .info

        #expect(domainLevels[networkDomain] == .debug)
        #expect(domainLevels[databaseDomain] == .info)
        #expect(domainLevels.count == 2)
    }

    @Test("LoggerDomain can be used in Set")
    func setUsage() {
        var domains: Set<LoggerDomain> = []

        domains.insert("Network")
        domains.insert("Database")
        domains.insert("Network") // Duplicate

        #expect(domains.count == 2)
        #expect(domains.contains("Network"))
        #expect(domains.contains("Database"))
        #expect(!domains.contains("UI"))
    }

    @Test("LoggerDomain is Sendable")
    func sendable() {
        let domain: LoggerDomain = "Network"

        Task {
            let domainInTask = domain
            #expect(domainInTask.description == "Network")
        }
    }

    @Test("LoggerDomain reusability pattern")
    func reusabilityPattern() {
        // Common pattern: creating domain constants
        let networkDomain: LoggerDomain = "Network"
        let databaseDomain: LoggerDomain = "Database"

        // Reuse domains across the codebase
        let domains = [networkDomain, databaseDomain]

        #expect(domains.count == 2)
        #expect(domains[0] == networkDomain)
        #expect(domains[1] == databaseDomain)
    }

    @Test("LoggerDomain with empty string")
    func emptyString() {
        let domain: LoggerDomain = ""
        #expect(domain.description == "")
    }

    @Test("LoggerDomain with special characters")
    func specialCharacters() {
        let domain1: LoggerDomain = "Network/API"
        let domain2: LoggerDomain = "Database.Core"
        let domain3: LoggerDomain = "UI-Components"

        #expect(domain1.description == "Network/API")
        #expect(domain2.description == "Database.Core")
        #expect(domain3.description == "UI-Components")
    }

    @Test("LoggerDomain string interpolation")
    func stringInterpolation() {
        let domain: LoggerDomain = "Network"
        let message = "Logging to domain: \(domain)"

        #expect(message == "Logging to domain: Network")
    }
}
