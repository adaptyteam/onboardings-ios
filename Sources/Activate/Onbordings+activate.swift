//
//  Onbordings+activate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public struct Octoflows: Sendable {
    let configuration: Configuration

    @OctoflowsActor
    private init(configuration: Configuration) async throws {
        self.configuration = configuration
        await Log.set(level: configuration.logLevel, handler: configuration.logHandler)
        Log.info("SDK Activated with configuration: \(configuration)")
    }
}

extension Octoflows {
    @MainActor
    private static var shared: Task<Octoflows, Error>?

    package static var activated: Octoflows {
        get async throws {
            if let task = await shared {
                try await task.value
            } else {
                throw OctoflowsError.notActivated()
            }
        }
    }

    @MainActor
    static func startActivate(with configuration: Configuration) throws {
        guard shared == nil else {
            throw OctoflowsError.activateOnce()
        }

        shared = Task {
            try await Octoflows(configuration: configuration)
        }
    }
}
