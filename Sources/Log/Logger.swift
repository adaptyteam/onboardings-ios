//
//  Logger.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

actor Logger {
    private(set) var handler: Octoflows.LogHandler = Octoflows.defaultLogHandler
    private(set) var level: Octoflows.LogLevel = .default

    init() {}

    func set(level: Octoflows.LogLevel, handler: @escaping Octoflows.LogHandler) {
        self.level = level
        self.handler = handler
    }

    func isLevel(_ value: Octoflows.LogLevel) -> Bool {
        level.rawValue >= value.rawValue
    }

    func write(_ time: Date, _ level: Octoflows.LogLevel, _ message: @escaping () -> String, file: String, function _: String, line: UInt) {
        guard isLevel(level) else { return }
        if isLevel(.debug) {
            handler(time, level, "[Octoflows v\(Octoflows.SDKVersion)] - \(level)\t\(file)#\(line): \(message())")
        } else {
            handler(time, level, "[Octoflows v\(Octoflows.SDKVersion)] - \(level): \(message())")
        }
    }
}
