//
//  Onboardings+activate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public struct Onboardings: Sendable {
    let configuration: Configuration

    @OnboardingsActor
    private init(configuration: Configuration) async throws {
        self.configuration = configuration
        await Log.set(level: configuration.logLevel, handler: configuration.logHandler)
        Log.info("SDK Activated with configuration: \(configuration)")
    }
}

extension Onboardings {
    @MainActor
    private static var shared: Task<Onboardings, Error>?

    package static var activated: Onboardings {
        get async throws {
            if let task = await shared {
                try await task.value
            } else {
                throw OnboardingsError.notActivated()
            }
        }
    }

    @MainActor
    static func startActivate(with configuration: Configuration) throws {
        guard shared == nil else {
            throw OnboardingsError.activateOnce()
        }

        shared = Task {
            try await Onboardings(configuration: configuration)
        }
    }
}
