//
//  Log.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

package enum Log {
    internal static var level: Octoflows.LogLevel = .default

    package static func isLevel(_ value: Octoflows.LogLevel) -> Bool {
        level.rawValue >= value.rawValue
    }

    internal static var handler: Octoflows.LogHandler = { NSLog("%@", $2) }

    private static let dispatchQueue = DispatchQueue(label: "Octoflows.Logger")

    private static func write(_ time: Date, _ level: Octoflows.LogLevel, _ message: @escaping () -> String, file: String, function _: String, line: UInt) {
        guard Log.isLevel(level) else { return }
        if Log.isLevel(.debug) {
            handler(time, level, "[Octoflows v\(Octoflows.SDKVersion)] - \(level)\t\(file)#\(line): \(message())")
        } else {
            handler(time, level, "[Octoflows v\(Octoflows.SDKVersion)] - \(level): \(message())")
        }
    }

    private static func asyncWrite(_ time: Date, _ level: Octoflows.LogLevel, _ message: @escaping () -> String, file: String, function: String, line: UInt) {
        dispatchQueue.async { write(time, level, message, file: file, function: function, line: line) }
    }

    @inlinable
    package static func message(_ level: Octoflows.LogLevel, _ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), level, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func message(_ level: Octoflows.LogLevel, message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), level, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func error(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .error, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func error(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .error, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func warn(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .warn, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func warn(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .warn, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func info(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .info, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func info(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .info, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func verbose(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .verbose, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func verbose(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .verbose, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func debug(_ message: @autoclosure @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .debug, message, file: file, function: function, line: line)
    }

    @inlinable
    package static func debug(message: @escaping () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        Log.asyncWrite(Date(), .debug, message, file: file, function: function, line: line)
    }
}
