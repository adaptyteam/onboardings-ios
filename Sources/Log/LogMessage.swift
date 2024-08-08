//
//  LogMessage.swift
//
//
//  Created by Aleksei Valiano on 06.08.2024
//
//

import Foundation

extension Onboardings {
    public struct LogMessage: Sendable {
        public let date: Date
        public let level: Onboardings.LogLevel
        public let message: String
        public let source: Source
    }
}

extension Onboardings.LogMessage {
    public struct Source: Sendable {
        public let sdkVersion: String
        public let threadName: String
        public let fileName: String
        public let functionName: String
        public let lineNumber: UInt
    }
}

extension Onboardings.LogMessage: CustomStringConvertible, CustomDebugStringConvertible {
    private static let dateFormatter: DateFormatter = {
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

extension Onboardings.LogMessage.Source: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "[Onboardings v\(sdkVersion)]"
    }

    public var debugDescription: String {
        "[Onboardings v\(sdkVersion)]  thrd: \(threadName), func: \(functionName)]\t \(fileName)#\(lineNumber)]"
    }
}
