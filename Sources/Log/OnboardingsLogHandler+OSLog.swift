//
//  OnboardingsLogHandler+OSLog.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation
import os.log

#if swift(<6.0)
    extension OSLog: @unchecked Sendable {}
#endif

extension Log {
    private static let logger = OSLog(subsystem: "io.adapty.onboardings", category: "sdk")

    @Sendable
    static func defaultLogHandler(_ msg: OnboardingsLogMessage) {
        os_log(msg.level.asOSLogType, log: logger, "%@\n%@", msg.value, msg.source.debugDescription)
    }
}

private extension OnboardingsLogLevel {
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
