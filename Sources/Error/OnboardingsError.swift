//
//  OnboardingsError.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public enum OnboardingsError: Error, Sendable {
    case wrongApiKey(Source, description: String)
    case notActivated(Source)
    case activateOnce(Source)
    case webKit(Source, Error)
}

public extension OnboardingsError {
    var source: Source {
        switch self {
        case let .wrongApiKey(src, _),
             let .activateOnce(src),
             let .notActivated(src),
             let .webKit(src, _):
            src
        }
    }

    var underlyingError: Error? {
        switch self {
        case let .webKit(_, error): error
        default:
            nil
        }
    }
}

extension OnboardingsError {
    static func wrongApiKey(
        description: String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .wrongApiKey(OnboardingsError.Source(file: file, function: function, line: line), description: description)
    }

    static func activateOnce(
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .activateOnce(OnboardingsError.Source(file: file, function: function, line: line))
    }

    static func notActivated(
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .notActivated(OnboardingsError.Source(file: file, function: function, line: line))
    }
    
    static func webKit(
        error: Error,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) -> Self {
        .webKit(OnboardingsError.Source(file: file, function: function, line: line), error)
    }
}
