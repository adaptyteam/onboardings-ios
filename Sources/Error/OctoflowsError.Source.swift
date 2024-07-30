//
//  OctoflowsError.Source.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension OctoflowsError {
    public struct Source: Sendable, Equatable {
        public let version = Octoflows.SDKVersion
        public let file: String
        public let function: String
        public let line: UInt

        public init(file: String = #fileID, function: String = #function, line: UInt = #line) {
            self.file = file
            self.function = function
            self.line = line
        }
    }
}

extension OctoflowsError.Source: CustomStringConvertible {
    public var description: String { "[\(version)]: \(file)#\(line)" }
}
