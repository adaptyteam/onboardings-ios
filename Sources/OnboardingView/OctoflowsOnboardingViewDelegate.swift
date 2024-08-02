//
//  OctoflowsOnboardingViewDelegate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public protocol OctoflowsOnboardingViewDelegate {
//    func recived(from: Octoflows, event: Octoflows.Event)
    
    func octoflowsSplashViewController() -> UIViewController?
    func octoflowsCloseAction()
}
