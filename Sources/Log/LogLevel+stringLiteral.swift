//
//  LogLevel+rawStringValue.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Octoflows.LogLevel: ExpressibleByStringLiteral {
    enum CodingValues: String {
        case error
        case warn
        case info
        case verbose
        case debug
    }

    public init(stringLiteral value: String) {
        self =
            switch CodingValues(rawValue: value.lowercased()) {
            case .none: .default
            case .error: .error
            case .warn: .warn
            case .info: .info
            case .verbose: .verbose
            case .debug: .debug
            }
    }

    var stringLiteral: String {
        let value: CodingValues =
            switch self {
            case .error: .error
            case .warn: .warn
            case .info: .info
            case .verbose: .verbose
            case .debug: .debug
            }
        return value.rawValue
    }
}

extension Octoflows.LogLevel: CustomStringConvertible {
    public var description: String { stringLiteral.uppercased() }
}
