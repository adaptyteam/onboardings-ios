//
//  OnboardingManager.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import Onboardings
import UIKit

final class OnboardingManager: NSObject {
    static let shared = OnboardingManager()

    fileprivate var window: UIWindow?

    @MainActor
    func initialize(scene: UIScene) -> UIWindow? {
        activateOnboardings()

        guard let windowScene = (scene as? UIWindowScene) else { return nil }

        window = UIWindow(windowScene: windowScene)
        presentOnboarding()
        return window
    }

    @MainActor
    func presentOnboarding() {
        guard let window else { return }

        window.rootViewController = Onboardings.createSplashController(
            id: "7-aug",
            delegate: self,
            splashDelegate: self
        )
        window.makeKeyAndVisible()
    }

    @MainActor
    private func activateOnboardings() {
        do {
            let configuration = try OnboardingsConfiguration
                .builder(withAPIKey: "") // TODO: insert apiKey
                .with(alternativeBaseUrl: URL(string: "https://1a.fnlfx.dev/")!) // TODO: remove
                .with(loglevel: .verbose)
                .build()

            try Onboardings.activate(with: configuration)
        } catch {
            // handle the error
            if let error = error as? OnboardingsError {
                // TODO: Log
            }
        }
    }
}

extension OnboardingManager: OnboardingDelegate {
    func onboardingsCloseAction(_ action: OnboardingsCloseAction) {
        guard let window else { return }

        window.rootViewController = ViewController.instantiate()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {}
        )
    }

    func openPaywallAction(_ action: OnboardingsOpenPaywallAction) {
        // TODO: Log
    }

    func customAction(_ action: OnboardingsCustomAction) {
        // TODO: Log
    }

    func stateUpdatedAction(_ action: OnboardingsStateUpdatedAction) {
        // TODO: Log
    }

    func onAnalyticsEvent(_ event : OnboardingsAnalyticsEvent) {
        // TODO: Log
    }

    func onLoadingError(_: Error) {
        // TODO: Show Error
    }
}

extension OnboardingManager: OnboardingSplashDelegate {
    func onboardingsSplashViewController() -> UIViewController? {
        SplashController.instantiate()
    }
}
