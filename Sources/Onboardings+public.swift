//
//  Onboardings+public.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public extension Octoflows {
    @MainActor
    static func activate(_ apiKey: String) throws {
        try activate(
            with: Configuration
                .builder(withAPIKey: apiKey)
                .build()
        )
    }

    @MainActor
    static func activate(with builder: Octoflows.Configuration.Builder) throws {
        try activate(with: builder.build())
    }

    @MainActor
    static func activate(with configuration: Octoflows.Configuration) throws {
        try startActivate(with: configuration)
    }

    @MainActor
    static func createOnboardingController(
        name: String,
        delegate: OnboardingDelegate,
        onFinishLoading: @escaping (Error?) -> Void
    ) async throws -> OnboardingController {
        try await activated.createOnboardingController(
            name: name,
            delegate: delegate,
            onFinishLoading: onFinishLoading
        )
    }

    @MainActor
    static func createSplashController(
        name: String,
        delegate: OnboardingDelegate,
        splashDelegate: OnboardingSplashDelegate
    ) -> OnboardingSplashController {
        OnboardingSplashController(
            name: name,
            delegate: delegate,
            splashDelegate: splashDelegate
        )
    }
}
