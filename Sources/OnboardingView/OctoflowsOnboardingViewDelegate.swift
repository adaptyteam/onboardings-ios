//
//  OctoflowsIntroViewDelegate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public protocol OctoflowsIntroViewDelegate {
    func recived(from: Octoflows, event: Octoflows.Event)
    
    func octoflowsSplashViewController(_ octoflows: Octoflows) -> UIViewController?
}
