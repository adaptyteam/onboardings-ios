//
//  OnboardingDelegate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

public protocol OnboardingDelegate: NSObjectProtocol {
    func onboardingsCloseAction()
}

public protocol OnboardingSplashDelegate: NSObjectProtocol {
    func onboardingsSplashViewController() -> UIViewController?
}
