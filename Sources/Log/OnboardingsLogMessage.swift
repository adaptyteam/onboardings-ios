//
//  OnboardingsLogMessage.swift
//
//
//  Created by Aleksei Valiano on 06.08.2024
//
//

import Foundation

public struct OnboardingsLogMessage: Sendable {
    public let date: Date
    public let level: OnboardingsLogLevel
    public let value: String
    public let source: Source
}

extension OnboardingsLogMessage {
    public struct Source: Equatable, Sendable {
        public let sdkVersion: String
        public let threadName: String
        public let fileName: String
        public let functionName: String
        public let lineNumber: UInt
    }
}

extension OnboardingsLogMessage: CustomStringConvertible, CustomDebugStringConvertible {
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
        "\(dateAsString) \(level.description) \(source.description):\t\(value)"
    }

    public var debugDescription: String {
        "\(dateAsString) \(level.description) \(source.debugDescription):\t\(value)"
    }
}

extension OnboardingsLogMessage.Source: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "[Onboardings v\(sdkVersion)]"
    }

    public var debugDescription: String {
        "[Onboardings v\(sdkVersion)]  thrd: \(threadName), func: \(functionName)]\t \(fileName)#\(lineNumber)]"
    }
}
