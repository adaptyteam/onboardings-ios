//
//  Octoflows.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public actor Octoflows {
    static var shared: Octoflows?

    let configuration: Configuration

    init(configuration: Configuration) async throws {
        self.configuration = configuration
        await Log.set(level: configuration.logLevel, handler: configuration.logHandler)
    }
}
