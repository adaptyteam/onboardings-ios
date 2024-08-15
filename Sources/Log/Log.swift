//
//  Log.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

package enum Log {
    private final class Storage: @unchecked Sendable {
        var level: OnboardingsLogLevel = .default
    }

    private static let _storage = Storage()
    package static var level: OnboardingsLogLevel {
        _storage.level
    }

    @LogActor
    private(set) static var handler: OnboardingsLogHandler = Log.defaultLogHandler

    @LogActor
    static func set(level: OnboardingsLogLevel, handler: @escaping OnboardingsLogHandler) async {
        Log.handler = handler
        _storage.level = level
    }

    @LogActor
    private static func write(message: OnboardingsLogMessage) {
        handler(message)
    }

    @inlinable
    nonisolated static func message(
        _ message: @autoclosure () -> Message,
        withLevel level: OnboardingsLogLevel,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        guard self.level >= level else { return }
        let message = OnboardingsLogMessage(
            date: Date(),
            level: level,
            value: message().value,
            source: .init(
                sdkVersion: Onboardings.SDKVersion,
                threadName: Log.currentThreadName,
                fileName: file,
                functionName: function,
                lineNumber: line
            )
        )
        Task.detached(priority: .utility) {
            await Log.write(message: message)
        }
    }
}

package extension Log {
    @inlinable
    nonisolated static func error(_ message: @autoclosure () -> Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(message(), withLevel: .error, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func warn(_ message: @autoclosure () -> Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(message(), withLevel: .warn, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func info(_ message: @autoclosure () -> Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(message(), withLevel: .info, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func verbose(_ message: @autoclosure () -> Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(message(), withLevel: .verbose, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func debug(_ message: @autoclosure () -> Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(message(), withLevel: .debug, file: file, function: function, line: line)
    }
}
