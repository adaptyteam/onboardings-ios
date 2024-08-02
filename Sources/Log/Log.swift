//
//  Log.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

package enum Log {
    private static let logger = Logger()

    @inlinable
    static func set(level: Octoflows.LogLevel, handler: @escaping Octoflows.LogHandler) async {
        await logger.set(level: level, handler: handler)
    }

    @inline(__always)
    private static func writeAsync(_ time: Date, _ level: Octoflows.LogLevel, _ message: @escaping () -> String, file: String, function: String, line: UInt) {
        Task(priority: .utility) {
            await Log.logger.write(time, level, message, file: file, function: function, line: line)
        }
    }
}

package extension Log {
    @inlinable
    static func message(_ level: Octoflows.LogLevel, _ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), level, message, file: file, function: function, line: line)
    }

    @inlinable
    static func message(_ level: Octoflows.LogLevel, message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), level, message, file: file, function: function, line: line)
    }

    @inlinable
    static func error(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .error, message, file: file, function: function, line: line)
    }

    @inlinable
    static func error(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .error, message, file: file, function: function, line: line)
    }

    @inlinable
    static func warn(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .warn, message, file: file, function: function, line: line)
    }

    @inlinable
    static func warn(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .warn, message, file: file, function: function, line: line)
    }

    @inlinable
    static func info(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .info, message, file: file, function: function, line: line)
    }

    @inlinable
    static func info(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .info, message, file: file, function: function, line: line)
    }

    @inlinable
    static func verbose(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .verbose, message, file: file, function: function, line: line)
    }

    @inlinable
    static func verbose(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .verbose, message, file: file, function: function, line: line)
    }

    @inlinable
    static func debug(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .debug, message, file: file, function: function, line: line)
    }

    @inlinable
    static func debug(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.writeAsync(Date(), .debug, message, file: file, function: function, line: line)
    }
}
