//
//  OnboardingsLog.Level.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Log {
    package typealias Level = OnboardingsLog.Level
}

extension OnboardingsLog {
    public enum Level: Int, Sendable {
        public static let `default` = Level.info

        /// Only errors will be logged
        case error
        /// `.error` +  messages from the SDK that do not cause critical errors, but are worth paying attention to
        case warn
        /// `.warn` +  information messages, such as those that log the lifecycle of various modules
        case info
        /// `.info` + any additional information that may be useful during debugging, such as function calls, API queries, etc.
        case verbose
        /// Debug purposes logging level
        case debug
    }
}

extension OnboardingsLog.Level: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
