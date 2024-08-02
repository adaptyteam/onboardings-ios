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
        try await activate(with: builder.build())
    }

    static func activate(with configuration: Octoflows.Configuration) async throws {
        guard shared == nil else {
            throw OctoflowsError.activateOnce()
        }

        shared = try await Octoflows(configuration: configuration)
    }

    static func getOnboardingView(name: String) async throws -> OctoflowsOnboardingView.Configuration {
        guard let sdk = shared else {
            throw OctoflowsError.notActivated()
        }

        return try await sdk.getOnboardingView(name: name)
    }

}

public extension Octoflows {
    @MainActor 
    static func createOnboardingController(
        delegate: OctoflowsOnboardingViewDelegate
    ) -> UIViewController {
//        OctoflowsOnboardingViewController(url: <#T##URL#>)
//        UIViewController()
        let vc = OctoflowsOnboardingViewController(
            url: URL(string: "https://x.fnlfx.com/funnel_a")!,
            delegate: delegate
        )
        
        return vc
    }
}
