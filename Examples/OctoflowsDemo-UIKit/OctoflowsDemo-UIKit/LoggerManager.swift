//
//  LoggerManager.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import Foundation
import Octoflows
import OSLog

extension Octoflows.LogLevel {
    var osLogLevel: OSLogType {
        switch self {
        case .error: .error
        case .warn: .fault
        case .info: .info
        case .verbose: .debug
        case .debug: .debug
        }
    }
}

extension Logger {
    private static let subsystem = "io.octoflows.sdk"
    static let internalLogger = Logger(subsystem: subsystem, category: "internal")

    func log(_ level: Octoflows.LogLevel, _ message: String) {
        log(level: level.osLogLevel, "\(message)")
    }
}

actor ApplicationLogger {
    static func handle(_ time: Date, _ level: Octoflows.LogLevel, _ message: String) {
        Logger.internalLogger.log(level, message)
    }
}
