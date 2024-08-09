//
//  Log.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

package enum Log {
    @LogActor
    private(set) static var handler: OnboardingsLogHandler = Log.defaultLogHandler
    @LogActor
    private(set) static var level: OnboardingsLogLevel = .default

    @LogActor
    package static func isLevel(_ value: OnboardingsLogLevel) -> Bool {
        level.rawValue >= value.rawValue
    }

    @LogActor
    static func set(level: OnboardingsLogLevel, handler: @escaping OnboardingsLogHandler) async {
        Log.handler = handler
        Log.level = level
    }

    @LogActor
    private static func write(
        date: Date,
        level: OnboardingsLogLevel,
        message: @escaping () -> String,
        threadName: String,
        fileName: String,
        functionName: String,
        lineNumber: UInt
    ) {
        guard isLevel(level) else { return }
        handler(.init(
            date: date,
            level: level,
            message: message(),
            source: .init(
                sdkVersion: Onboardings.SDKVersion,
                threadName: threadName,
                fileName: fileName,
                functionName: functionName,
                lineNumber: lineNumber
            )
        ))
    }
}

package extension Log {
    @inlinable
    nonisolated static func message(level: OnboardingsLogLevel, message: @Sendable @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        let threadName = Log.currentThreadName
        Task(priority: .utility) {
            await Log.write(date: Date(), level: level, message: message, threadName: threadName, fileName: file, functionName: function, lineNumber: line)
        }
    }

    @inlinable
    nonisolated static func error(message: @Sendable @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .error, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func warn(message: @Sendable @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .warn, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func info(message: @Sendable @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .info, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func verbose(message: @Sendable @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .verbose, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func debug(message: @Sendable @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .debug, message: message, file: file, function: function, line: line)
    }
}

package extension Log {
    @inlinable
    nonisolated static func message(_ level: OnboardingsLogLevel, _ message: @Sendable @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: level, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func error(_ message: @Sendable @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .error, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func warn(_ message: @Sendable @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .warn, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func info(_ message: @Sendable @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .info, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func verbose(_ message: @Sendable @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .verbose, message: message, file: file, function: function, line: line)
    }

    @inlinable
    nonisolated static func debug(_ message: @Sendable @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.message(level: .debug, message: message, file: file, function: function, line: line)
    }
}
