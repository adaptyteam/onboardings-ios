//
//  OctoflowsOnboardingViewDelegate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

public protocol OnboardingDelegate: NSObjectProtocol {
    func octoflowsCloseAction()
}

public protocol OnboardingSplashDelegate: NSObjectProtocol {
    func octoflowsSplashViewController() -> UIViewController?
}
