//
//  OnbordingsError.Source.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension OnbordingsError {
    public struct Source: Sendable {
        public let version = Onbordings.SDKVersion
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

extension OnbordingsError.Source: CustomStringConvertible {
    public var description: String { "[\(version)]: \(file)#\(line)" }
}
