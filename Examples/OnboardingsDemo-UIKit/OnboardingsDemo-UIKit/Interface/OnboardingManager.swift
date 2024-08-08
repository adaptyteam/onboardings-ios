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
            name: "funnel_a",
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
                .with(alternativeBaseUrl: URL(string: "https://x.fnlfx.com/")!) // TODO: remove
                .with(loglevel: .verbose)
                .build()

            try Onbordings.activate(with: configuration)
        } catch {
            // handle the error
            if let error = error as? OnbordingsError {}
        }
    }
}

extension OnboardingManager: OnboardingDelegate {
    func onboardingsCloseAction(clientId: String, withMeta: Onbordings.MetaParameters) {
        guard let window else { return }

        window.rootViewController = ViewController.instantiate()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {}
        )
    }

    func openPaywallAction(clientId: String, withMeta: Onbordings.MetaParameters) {}

    func customAction(clientId: String, withMeta: Onbordings.MetaParameters) {}

    func stateUpdated(clientId: String, params: Onbordings.StateUpdatedParameters, withMeta: Onbordings.MetaParameters) {}

    func onAnalyticsEvent(event: Onbordings.AnalyticsEvent) {}
}

extension OnboardingManager: OnboardingSplashDelegate {
    func onboardingsSplashViewController() -> UIViewController? {
        SplashController.instantiate()
    }
}
