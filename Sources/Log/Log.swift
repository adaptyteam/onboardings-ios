//
//  Log.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

package enum Log {
    @globalActor
    package actor InternalActor {
        package static let shared = InternalActor()
    }

    private final class Storage: @unchecked Sendable {
        var level: OnboardingsLog.Level = .default
    }

    private static let _storage = Storage()
    package static var level: OnboardingsLog.Level {
        _storage.level
    }

    @InternalActor
    private(set) static var handler: OnboardingsLog.Handler?

    @InternalActor
    static func set(level: OnboardingsLog.Level, handler: OnboardingsLog.Handler?) async {
        Log.handler = handler
        _storage.level = level
    }

    @InternalActor
    private static func handlerWrite(_ record: OnboardingsLog.Record) {
        handler?(record)
    }

    fileprivate static func write(record: OnboardingsLog.Record) {
        Task.detached(priority: .utility) {
            await osLogWrite(record)
            await handlerWrite(record)
        }
    }
}

private extension OnboardingsLog.Category {
    func write(
        _ message: String,
        withLevel level: OnboardingsLog.Level,
        file: String,
        function: String,
        line: UInt
    ) {
        guard Log.level >= level else { return }

        Log.write(record: .init(
            date: Date(),
            level: level,
            message: message,
            category: self,
            source: .init(
                threadName: Log.currentThreadName,
                fileName: file,
                functionName: function,
                lineNumber: line
            )
        ))
    }
}

package extension OnboardingsLog.Category {
    func message(_ message: @autoclosure () -> String, withLevel level: OnboardingsLog.Level, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message(), withLevel: level, file: file, function: function, line: line)
    }

    func message(_ message: @autoclosure () -> Log.Message, withLevel level: OnboardingsLog.Level, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message().value, withLevel: level, file: file, function: function, line: line)
    }

    func error(_ message: @autoclosure () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message(), withLevel: .error, file: file, function: function, line: line)
    }

    func error(_ message: @autoclosure () -> Log.Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message().value, withLevel: .error, file: file, function: function, line: line)
    }

    func warn(_ message: @autoclosure () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message(), withLevel: .warn, file: file, function: function, line: line)
    }

    func warn(_ message: @autoclosure () -> Log.Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message().value, withLevel: .warn, file: file, function: function, line: line)
    }

    func info(_ message: @autoclosure () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message(), withLevel: .info, file: file, function: function, line: line)
    }

    func info(_ message: @autoclosure () -> Log.Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message().value, withLevel: .info, file: file, function: function, line: line)
    }

    func verbose(_ message: @autoclosure () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message(), withLevel: .verbose, file: file, function: function, line: line)
    }

    func verbose(_ message: @autoclosure () -> Log.Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message().value, withLevel: .verbose, file: file, function: function, line: line)
    }

    func debug(_ message: @autoclosure () -> String, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message(), withLevel: .debug, file: file, function: function, line: line)
    }

    func debug(_ message: @autoclosure () -> Log.Message, file: String = #fileID, function: String = #function, line: UInt = #line) {
        write(message().value, withLevel: .debug, file: file, function: function, line: line)
    }
}
