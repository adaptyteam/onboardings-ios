//
//  Onboardings+public.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public extension Onboardings {
    @MainActor
    static func activate(_ apiKey: String) throws {
        try activate(
            with: Configuration
                .builder(withAPIKey: apiKey)
                .build()
        )
    }

    @MainActor
    static func activate(with builder: Onboardings.Configuration.Builder) throws {
        try activate(with: builder.build())
    }

    @MainActor
    static func activate(with configuration: Onboardings.Configuration) throws {
        try startActivate(with: configuration)
    }

    static func getOnboardingURL(id: String) async throws -> URL { // TODO: remove , the URL of the onboarding's data must be internal
        let instance = try await activated
        return instance.configuration.onboardingUrl(onboardingId: id)
    }

    @MainActor
    static func createOnboardingController(
        id: String,
        delegate: OnboardingDelegate,
        onFinishLoading: @escaping () -> Void
    ) async throws -> OnboardingController {
        try await activated.createOnboardingController(
            id: id,
            delegate: delegate,
            onFinishLoading: onFinishLoading
        )
    }

    @MainActor
    static func createSplashController(
        id: String,
        delegate: OnboardingDelegate,
        splashDelegate: OnboardingSplashDelegate
    ) -> OnboardingSplashController {
        OnboardingSplashController(
            id: id,
            delegate: delegate,
            splashDelegate: splashDelegate
        )
    }
}
