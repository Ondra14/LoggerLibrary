//
//  CustomLogHandler.swift
//
//
//  Created by Ondřej Veselý on 16.09.2024.
//

import Foundation
import Logging // Import Apple's Swift Logging API

public class FileLogHandler: LogHandler {
    public var metadata = Logger.Metadata()
    public var logLevel: Logger.Level = .info

    private let label: String
    private let logFileHandle: FileHandle

    public init(label: String) {
        self.label = label

        // Define the log file path
        let logFilePath = FileManager.default.temporaryDirectory.appendingPathComponent("app.log").path

        // Create the log file if it doesn't exist
        if !FileManager.default.fileExists(atPath: logFilePath) {
            FileManager.default.createFile(atPath: logFilePath, contents: nil, attributes: nil)
        }

        logFileHandle = FileHandle(forWritingAtPath: logFilePath)!
        logFileHandle.seekToEndOfFile() // Append to the end of the file
    }

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get {
            return metadata[key]
        }
        set {
            metadata[key] = newValue
        }
    }

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let metadataPart = (metadata ?? [:]).map { "\($0)=\($1)" }.joined(separator: " ")
        let logMessage = "\(timestamp) \(message) \(metadataPart)\n"
        print(logMessage)
        // Write the log message to the file
        if let data = logMessage.data(using: .utf8) {
            logFileHandle.write(data)
        }
    }

    public func flush() {
        // Ensure the file is flushed to disk
        logFileHandle.synchronizeFile()
    }

    deinit {
        logFileHandle.closeFile()
    }
}
