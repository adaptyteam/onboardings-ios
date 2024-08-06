//
//  Octoflows+public.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import UIKit

public extension Octoflows {
    static func activate(_ apiKey: String) async throws {
        try await activate(
            with: Configuration
                .builder(withAPIKey: apiKey)
                .build()
        )
    }

    static func activate(with builder: Octoflows.Configuration.Builder) async throws {
        try await activate(with: builder.build())
    }

    static func activate(with configuration: Octoflows.Configuration) async throws {
        try await startActivate(with: configuration)
    }

    @MainActor
    static func createOnboardingController(
        name: String,
        delegate: OnboardingSplashDelegate
    ) async throws -> UIViewController {
        try await activated.createOnboardingController(name: name, delegate: delegate)
    }
}
