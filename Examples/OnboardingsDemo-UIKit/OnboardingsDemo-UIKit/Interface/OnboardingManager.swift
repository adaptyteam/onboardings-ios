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
            id: "YOUR_ONBOARDING_ID",
            delegate: self,
            splashDelegate: self
        )
        window.makeKeyAndVisible()
    }

    @MainActor
    private func activateOnboardings() {
        do {
            let configuration = try OnboardingsConfiguration
                .builder(withAPIKey: "YOUR_API_KEY")
                .with(loglevel: .verbose)
                .build()

            try Onboardings.activate(with: configuration)
        } catch {
            // handle the error
        }
    }
}

extension OnboardingManager: OnboardingDelegate {
    func onboardingController(_ controller: UIViewController, onCloseAction action: OnboardingsCloseAction) {
        guard let window else { return }

        window.rootViewController = ViewController.instantiate()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {}
        )
    }

    func onboardingController(_ controller: UIViewController, didFailWithError error: OnboardingsError) {
        // TODO: Show Error
    }
}

extension OnboardingManager: OnboardingSplashDelegate {
    func onboardingsSplashViewController() -> UIViewController? {
        SplashController.instantiate()
    }
}
