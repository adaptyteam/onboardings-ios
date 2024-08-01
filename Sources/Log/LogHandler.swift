//
//  LogHandler.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Octoflows {
    public typealias LogHandler = (_ time: Date, _ level: LogLevel, _ message: String) -> Void
}
