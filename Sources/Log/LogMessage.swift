//
//  LogMessage.swift
//
//
//  Created by Aleksei Valiano on 06.08.2024
//
//

import Foundation

extension Octoflows {
    public struct LogMessage: Sendable {
        public let date: Date
        public let level: Octoflows.LogLevel
        public let message: String
        public let source: Source
    }
}

extension Octoflows.LogMessage {
    public struct Source: Sendable {
        public let sdkVersion: String
        public let threadName: String
        public let fileName: String
        public let functionName: String
        public let lineNumber: UInt
    }
}

extension Octoflows.LogMessage: CustomStringConvertible, CustomDebugStringConvertible {
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()

    private var dateAsString: String {
        Self.dateFormatter.string(from: date)
    }

    public var description: String {
        "\(dateAsString) \(level.description) \(source.description):\t\(message)"
    }

    public var debugDescription: String {
        "\(dateAsString) \(level.description) \(source.debugDescription):\t\(message)"
    }
}

extension Octoflows.LogMessage.Source: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "[Octoflows v\(sdkVersion)]"
    }

    public var debugDescription: String {
        "[Octoflows v\(sdkVersion)]  thrd: \(threadName), func: \(functionName)]\t \(fileName)#\(lineNumber)]"
    }
}
