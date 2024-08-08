//
//  OnboardingManager.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import Onbordings
import UIKit

final class OnboardingManager: NSObject {
    static let shared = OnboardingManager()

    fileprivate var window: UIWindow?

    @MainActor
    func initialize(scene: UIScene) -> UIWindow? {
        activateOnbordings()

        guard let windowScene = (scene as? UIWindowScene) else { return nil }

        window = UIWindow(windowScene: windowScene)
        presentOnboarding()
        return window
    }

    @MainActor
    func presentOnboarding() {
        guard let window else { return }

        window.rootViewController = Onbordings.createSplashController(
            id: "7-aug",
            delegate: self,
            splashDelegate: self
        )
        window.makeKeyAndVisible()
    }

    @MainActor
    private func activateOnbordings() {
        do {
            let configuration = try Onbordings.Configuration
                .Builder(withAPIKey: "") // TODO: insert apiKey
                .with(alternativeBaseUrl: URL(string: "https://1a.fnlfx.dev/")!) // TODO: remove
                .with(loglevel: .verbose)
                .build()

            try Onbordings.activate(with: configuration)
        } catch {
            // handle the error
            if let error = error as? OnbordingsError {
                // TODO: Log
            }
        }
    }
}

extension OnboardingManager: OnboardingDelegate {
    func onboardingsCloseAction(clientId _: String, withMeta _: Onbordings.MetaParameters) {
        guard let window else { return }

        window.rootViewController = ViewController.instantiate()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {}
        )
    }

    func openPaywallAction(clientId _: String, withMeta _: Onbordings.MetaParameters) {
        // TODO: Log
    }

    func customAction(clientId _: String, withMeta _: Onbordings.MetaParameters) {
        // TODO: Log
    }

    func stateUpdated(clientId _: String, params _: Onbordings.StateUpdatedParameters, withMeta _: Onbordings.MetaParameters) {
        // TODO: Log
    }

    func onAnalyticsEvent(event _: Onbordings.AnalyticsEvent) {
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
