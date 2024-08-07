//
//  OnbordingsError.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public enum OnbordingsError: Error, Sendable {
    case wrongApiKey(Source, description: String)
    case notActivated(Source)
    case activateOnce(Source)
}

extension OnbordingsError {
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

extension OnbordingsError {
    static func wrongApiKey(
        description: String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .wrongApiKey(OnbordingsError.Source(file: file, function: function, line: line), description: description)
    }

    static func activateOnce(
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .activateOnce(OnbordingsError.Source(file: file, function: function, line: line))
    }

    static func notActivated(
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .notActivated(OnbordingsError.Source(file: file, function: function, line: line))
    }
}
