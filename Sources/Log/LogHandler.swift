//
//  LogHandler.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation
import os.log

extension Octoflows {
    public typealias LogHandler = @Sendable (LogMessage) -> Void

    private static let logger = OSLog(subsystem: "io.adapty.octoflows", category: "sdk")

    @Sendable
    static func defaultLogHandler(_ msg: LogMessage) {
        os_log(msg.level.asOSLogType, log: logger, "%@\n%@", msg.message, msg.source.debugDescription)
    }
}

private extension Octoflows.LogLevel {
    var asOSLogType: OSLogType {
        switch self {
        case .error:
            .fault
        case .warn:
            .error
        case .info:
            .default
        case .verbose:
            .info
        case .debug:
            .debug
        }
    }
}
