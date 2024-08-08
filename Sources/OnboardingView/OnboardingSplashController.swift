//
//  OnboardingSplashController.swift
//  Onbordings
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import UIKit

public class OnboardingSplashController: UIViewController {
    private let id: String

    private weak var applicationSplashVC: UIViewController?
    private weak var onboardingVC: OnboardingController?

    private weak var delegate: OnboardingDelegate!
    private weak var splashDelegate: OnboardingSplashDelegate!

    @MainActor
    init(
        id: String,
        delegate: OnboardingDelegate,
        splashDelegate: OnboardingSplashDelegate
    ) {
        self.id = id
        self.delegate = delegate
        self.splashDelegate = splashDelegate

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        applicationSplashVC = layoutApplicationSplash()

        Task {
            onboardingVC = try? await layoutOnboarding()
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        applicationSplashVC?.beginAppearanceTransition(true, animated: animated)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        applicationSplashVC?.endAppearanceTransition()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        applicationSplashVC?.beginAppearanceTransition(false, animated: animated)
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        applicationSplashVC?.endAppearanceTransition()
    }

    private func layoutOnboarding() async throws -> OnboardingController {
        let onboardingVC = try await Onbordings.createOnboardingController(
            id: id,
            delegate: delegate,
            onFinishLoading: { [weak self] in
                self?.removeApplicationSplash()
            }
        )

        layoutChildController(onboardingVC, at: 0)
        return onboardingVC
    }

    private func layoutChildController(_ childVC: UIViewController, at index: Int? = nil) {
        if let index {
            view.insertSubview(childVC.view, at: index)
        } else {
            view.addSubview(childVC.view)
        }

        addChild(childVC)
        childVC.didMove(toParent: self)

        view.addConstraints([
            childVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        childVC.view.clipsToBounds = true
    }

    private func layoutApplicationSplash() -> UIViewController? {
        guard let splashDelegate,
              let childVC = splashDelegate.onboardingsSplashViewController()
        else {
            return nil
        }

        layoutChildController(childVC)

        return childVC
    }

    private func removeApplicationSplash() {
        guard let applicationSplashVC else { return }

        UIView.animate(
            withDuration: 0.3,
            delay: 0.5,
            animations: {
                applicationSplashVC.view.alpha = 0.0

            }, completion: { _ in
                applicationSplashVC.willMove(toParent: nil)
                applicationSplashVC.view.removeFromSuperview()
                applicationSplashVC.removeFromParent()

                self.applicationSplashVC = nil
            }
        )
    }
}
