//
//  OnboardingManager.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import Octoflows
import UIKit

final class OnboardingManager {
    static let shared = OnboardingManager()

    fileprivate let storyboard = UIStoryboard(name: "Main", bundle: nil)
    fileprivate var window: UIWindow?

    @MainActor
    func initialize(scene: UIScene) -> UIWindow? {
        activateOctoflows()

        guard let windowScene = (scene as? UIWindowScene) else { return nil }

        let window = UIWindow(windowScene: windowScene)

        window.rootViewController = Octoflows.createOnboardingController(
            delegate: self
        )
        window.makeKeyAndVisible()

        self.window = window

        return window
    }

    private func activateOctoflows() {
        Task {
            do {
                let configuration = try Octoflows.Configuration
                    .Builder(withAPIKey: "")
                    .with(loglevel: .verbose)
                    .with(logHandler: { time, level, message in
                        ApplicationLogger.handle(time, level, message)
                    })
                    .build()

                try await Octoflows.activate(with: configuration)
            } catch {
                // handle the error
            }
        }
    }
}

extension OnboardingManager: OctoflowsOnboardingViewDelegate {
    func octoflowsSplashViewController() -> UIViewController? {
        storyboard.instantiateViewController(identifier: "SplashViewController")
    }

    func octoflowsCloseAction() {
        window?.rootViewController = storyboard.instantiateInitialViewController()
    }
}
