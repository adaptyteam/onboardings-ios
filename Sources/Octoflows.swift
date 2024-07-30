//
//  Octoflows.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public enum Octoflows {
//    public static var isActivated: Bool { shared != nil }

    public static func activate(_ apiKey: String) async throws {
        try await activate(
            with: Configuration
                .builder(withAPIKey: apiKey)
                .build()
        )
    }

    public static func activate(with builder: Octoflows.Configuration.Builder) async throws {
        try await activate(with:
            builder.build()
        )
    }

    public static func activate(with _: Octoflows.Configuration) async throws {}

    /// Set to the most appropriate level of logging
    public static var logLevel: LogLevel {
        get { Log.level }
        set { Log.level = newValue }
    }

    /// Override the default logger behavior using this method
    /// - Parameter handler: The function will be called for each message with the appropriate `logLevel`
    public static func setLogHandler(_ handler: @escaping LogHandler) {
        Log.handler = handler
    }
}
