//
//  Onboardings+public.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation
import SwiftUI

public extension Onboardings {
    @MainActor
    static func activate(_ apiKey: String) throws {
        try activate(
            with: OnboardingsConfiguration
                .builder(withAPIKey: apiKey)
                .build()
        )
    }

    @MainActor
    static func activate(with builder: OnboardingsConfigurationBuilder) throws {
        try activate(with: builder.build())
    }

    @MainActor
    static func activate(with configuration: OnboardingsConfiguration) throws {
        try startActivate(with: configuration)
    }

    @MainActor
    static func createOnboardingController(
        id: String,
        delegate: OnboardingDelegate
    ) async throws -> OnboardingController {
        try await activated.createOnboardingController(
            id: id,
            delegate: delegate
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

    @MainActor
    static func swiftuiView<Splash: View>(
        id: String,
        splashViewBuilder: @escaping () -> Splash,
        onCloseAction: @escaping (OnboardingsCloseAction) -> Void,
        onOpenPaywallAction: ((OnboardingsOpenPaywallAction) -> Void)? = nil,
        onCustomAction: ((OnboardingsCustomAction) -> Void)? = nil,
        onStateUpdatedAction: ((OnboardingsStateUpdatedAction) -> Void)? = nil,
        onAnalyticsEvent: ((OnboardingsAnalyticsEvent) -> Void)? = nil,
        onError: @escaping (Error) -> Void
    ) -> some View {
        OnboardingSplashView(
            id: id,
            splashViewBuilder: splashViewBuilder,
            onCloseAction: onCloseAction,
            onOpenPaywallAction: onOpenPaywallAction,
            onCustomAction: onCustomAction,
            onStateUpdatedAction: onStateUpdatedAction,
            onAnalyticsEvent: onAnalyticsEvent,
            onError: onError
        )
    }
}
