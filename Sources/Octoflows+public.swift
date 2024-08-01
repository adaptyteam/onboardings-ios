//
//  Octoflows+public.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public extension Octoflows {
    static var isActivated: Bool { shared != nil }

    static func activate(_ apiKey: String) async throws {
        try await activate(
            with: Configuration
                .builder(withAPIKey: apiKey)
                .build()
        )
    }

    static func activate(with builder: Octoflows.Configuration.Builder) async throws {
        try await activate(with:
            builder.build()
        )
    }

    static func activate(with configuration: Octoflows.Configuration) async throws {
        guard shared == nil else {
            throw OctoflowsError.activateOnce()
        }

        shared = try Octoflows(configuration: configuration)
    }

    static func getInroView(name: String) async throws -> OctoflowsIntroView.Configuration {
        guard let sdk = shared else {
            throw OctoflowsError.notActivated()
        }

        return try await sdk.getInroView(name: name)
    }

    /// Set to the most appropriate level of logging
    static var logLevel: LogLevel {
        get { Log.level }
        set { Log.level = newValue }
    }

    /// Override the default logger behavior using this method
    /// - Parameter handler: The function will be called for each message with the appropriate `logLevel`
    static func setLogHandler(_ handler: @escaping LogHandler) {
        Log.handler = handler
    }
}
