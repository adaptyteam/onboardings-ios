//
//  OnboardingsError.Source.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension OnboardingsError {
    public struct Source: Sendable {
        public let version = Onboardings.SDKVersion
        public let file: String
        public let function: String
        public let line: UInt

        package init(file: String = #fileID, function: String = #function, line: UInt = #line) {
            self.file = file
            self.function = function
            self.line = line
        }
    }
}

extension OnboardingsError.Source: CustomStringConvertible {
    public var description: String { "[\(version)]: \(file)#\(line)" }
}
