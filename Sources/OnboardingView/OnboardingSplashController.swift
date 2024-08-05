//
//  OnboardingSplashController.swift
//  Octoflows
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import UIKit

public class OnboardingSplashController: OnboardingController {
    private weak var applicationSplashVC: UIViewController?

    public init(url: URL, delegate: OnboardingSplashDelegate) {
//        self.delegate = delegate
//        self.viewModel = OnboardingViewModel(url: url)

        super.init(url: url, delegate: delegate)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onFinishLoading = { [weak self] in
            self?.removeApplicationSplash()
        }
        
        applicationSplashVC = layoutApplicationSplash()
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

    private func layoutApplicationSplash() -> UIViewController? {
        guard let delegate = delegate as? OnboardingSplashDelegate,
              let childVC = delegate.octoflowsSplashViewController() else {
            return nil
        }

        view.addSubview(childVC.view)
        addChild(childVC)
        childVC.didMove(toParent: self)

        view.addConstraints([
            childVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        childVC.view.clipsToBounds = true

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
