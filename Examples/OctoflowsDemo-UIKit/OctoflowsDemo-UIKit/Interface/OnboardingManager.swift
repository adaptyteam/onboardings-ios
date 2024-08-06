//
//  OnboardingManager.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import Octoflows
import UIKit

final class OnboardingManager: NSObject {
    static let shared = OnboardingManager()

    fileprivate var window: UIWindow?

    @MainActor
    func initialize(scene: UIScene) -> UIWindow? {
        activateOctoflows()

        guard let windowScene = (scene as? UIWindowScene) else { return nil }

        self.window = UIWindow(windowScene: windowScene)
        presentOnboarding()
        return window
    }
    
    @MainActor 
    func presentOnboarding() {
        guard let window else { return }

        window.rootViewController = Octoflows.createSplashController(
            name: "test",
            delegate: self,
            splashDelegate: self
        )
        window.makeKeyAndVisible()
    }

    @MainActor
    private func activateOctoflows() {
        do {
            let configuration = try Octoflows.Configuration
                .Builder(withAPIKey: "")
                .with(loglevel: .verbose)
                .build()

            try Octoflows.activate(with: configuration)
        } catch let error as OctoflowsError {
            // handle the error
        }
    }
}

extension OnboardingManager: OnboardingDelegate {
    func octoflowsCloseAction() {
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
    func octoflowsSplashViewController() -> UIViewController? {
        SplashController.instantiate()
    }
}
