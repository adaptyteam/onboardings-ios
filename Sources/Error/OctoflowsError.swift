//
//  OctoflowsError.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public enum OctoflowsError: Error, Sendable {
    case wrongApiKey(Source, description: String)
    case notActivated(Source)
    case activateOnce(Source)
}

extension OctoflowsError {
    public var source: Source {
        switch self {
        case let .wrongApiKey(src, _),
             let .activateOnce(src),
             let .notActivated(src):
            src
        }
    }

    public var underlyingError: Error? {
        switch self {
        default:
            nil
        }
    }
}

extension OctoflowsError {
    static func wrongApiKey(
        description: String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .wrongApiKey(OctoflowsError.Source(file: file, function: function, line: line), description: description)
    }

    static func activateOnce(
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .activateOnce(OctoflowsError.Source(file: file, function: function, line: line))
    }

    static func notActivated(
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .notActivated(OctoflowsError.Source(file: file, function: function, line: line))
    }
}
