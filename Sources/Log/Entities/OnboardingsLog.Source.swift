//
//  OnboardingsLog.Source.swift
//
//
//  Created by Aleksei Valiano on 24.08.2024
//
//

import Foundation

extension Log {
    package typealias Source = OnboardingsLog.Source
}

extension OnboardingsLog {
    public struct Source: Equatable, Sendable {
        public let threadName: String
        public let fileName: String
        public let functionName: String
        public let lineNumber: UInt
    }
}

extension OnboardingsLog.Source: CustomStringConvertible {
    public var description: String {
        "thrd: \(threadName), func: \(functionName)\t \(fileName)#\(lineNumber)"
    }
}
