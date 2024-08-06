//
//  Octoflows.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public actor Octoflows {
    let configuration: Configuration

    private init(configuration: Configuration) async throws {
        self.configuration = configuration
        await Log.set(level: configuration.logLevel, handler: configuration.logHandler)
    }
}

extension Octoflows {
    private static let shared = Shared()

    private actor Shared {
        var task: Task<Octoflows, Error>?
        func setTaskOnce(_ task: @autoclosure () -> Task<Octoflows, Error>) throws {
            guard self.task == nil else {
                throw OctoflowsError.activateOnce()
            }
            self.task = task()
        }
    }

    package static var activated: Octoflows {
        get async throws {
            if let task = await shared.task {
                try await task.value
            } else {
                throw OctoflowsError.notActivated()
            }
        }
    }

    static func startActivate(with configuration: Configuration) async throws {
        try await shared.setTaskOnce(Task {
            try await Octoflows(configuration: configuration)
        })
    }
}
