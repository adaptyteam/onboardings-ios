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

extension Octoflows {
    @MainActor
    func createOnboardingController(
        name: String,
        delegate: OnboardingDelegate,
        onFinishLoading: @escaping (Error?) -> Void
    ) throws -> OnboardingController {
//        let url = configuration.baseUrl.appendingPathComponent(name)
        let url = URL(string: "https://x.fnlfx.com/funnel_a")!
        
        let vc = OnboardingController(
            url: url,
            delegate: delegate,
            onFinishLoading: onFinishLoading
        )

        return vc
    }
}
