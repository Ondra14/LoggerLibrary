//
//  LoggerDomain.swift
//  
//
//  Created by Ondřej Veselý on 20.01.2023.
//

/// The domain shared by the logs originating from the same ``Logger``.
public struct LoggerDomain: CustomStringConvertible, ExpressibleByStringLiteral, Hashable {
    public let description: String

    public init(stringLiteral value: String) {
        description = value
    }

    public init(_ description: String) {
        self.description = description
    }
}
