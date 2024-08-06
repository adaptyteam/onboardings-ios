//
//  OctoflowsOnboardingViewDelegate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

public protocol OnboardingDelegate {
//    func recived(from: Octoflows, event: Octoflows.Event)
    
    func octoflowsCloseAction()
}

public protocol OnboardingSplashDelegate: OnboardingDelegate {
    func octoflowsSplashViewController() -> UIViewController?
}
