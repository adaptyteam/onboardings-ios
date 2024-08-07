//
//  Onbordings+activate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public struct Onbordings: Sendable {
    let configuration: Configuration

    @OnbordingsActor
    private init(configuration: Configuration) async throws {
        self.configuration = configuration
        await Log.set(level: configuration.logLevel, handler: configuration.logHandler)
        Log.info("SDK Activated with configuration: \(configuration)")
    }
}

extension Onbordings {
    @MainActor
    private static var shared: Task<Onbordings, Error>?

    package static var activated: Onbordings {
        get async throws {
            if let task = await shared {
                try await task.value
            } else {
                throw OnbordingsError.notActivated()
            }
        }
    }

    @MainActor
    static func startActivate(with configuration: Configuration) throws {
        guard shared == nil else {
            throw OnbordingsError.activateOnce()
        }

        shared = Task {
            try await Onbordings(configuration: configuration)
        }
    }
}
