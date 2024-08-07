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

        self.window = UIWindow(windowScene: windowScene)
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
                .Builder(withAPIKey: "")  // TODO: insert apiKey
                .with(alternativeBaseUrl: URL(string: "https://x.fnlfx.com/")! ) // TODO: remove
                .with(loglevel: .verbose)
                .build()

            try Onbordings.activate(with: configuration)
        } catch let error as OnbordingsError {
            // handle the error
        }
    }
}

extension OnboardingManager: OnboardingDelegate {
    func onbordingsCloseAction() {
        guard let window else { return }

        window.rootViewController = ViewController.instantiate()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {}
        )
    }
}

extension OnboardingManager: OnboardingSplashDelegate {
    func onbordingsSplashViewController() -> UIViewController? {
        SplashController.instantiate()
    }
}
