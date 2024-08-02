//
//  LogHandler.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Octoflows {
    static let defaultLogHandler: LogHandler = { NSLog("%@", $2) }

    public typealias LogHandler = @Sendable (_ time: Date, _ level: LogLevel, _ message: String) -> Void
}

