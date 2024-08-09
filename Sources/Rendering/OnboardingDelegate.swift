//
//  OnboardingDelegate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

public protocol OnboardingDelegate: NSObjectProtocol {
    func onboardingControllerDidFinishLoading(_ controller: UIViewController)
    func onboardingController(_ controller: UIViewController, onCloseAction action: OnboardingsCloseAction)
    func onboardingController(_ controller: UIViewController, onPaywallAction action: OnboardingsOpenPaywallAction)
    func onboardingController(_ controller: UIViewController, onCustomAction action: OnboardingsCustomAction)
    func onboardingController(_ controller: UIViewController, onStateUpdatedAction action: OnboardingsStateUpdatedAction)
    func onboardingController(_ controller: UIViewController, onAnalyticsEvent event: OnboardingsAnalyticsEvent)
    func onboardingController(_ controller: UIViewController, didFailWithError error: OnboardingsError)
}

public protocol OnboardingSplashDelegate: NSObjectProtocol {
    func onboardingsSplashViewController() -> UIViewController?
}

public extension OnboardingDelegate {
    func onboardingController(_ controller: UIViewController, onPaywallAction action: OnboardingsOpenPaywallAction) {
        Log.warn("Not implemented method 'openPaywallAction' of OnboardingDelegate ")
    }

    func onboardingController(_ controller: UIViewController, onCustomAction action: OnboardingsCustomAction) {
        Log.warn("Not implemented method 'onCustomAction' of OnboardingDelegate ")
    }

    func onboardingController(_ controller: UIViewController, onStateUpdatedAction action: OnboardingsStateUpdatedAction) {
        Log.warn("Not implemented method 'onStateUpdatedAction' of OnboardingDelegate ")
    }

    func onboardingController(_ controller: UIViewController, onAnalyticsEvent event: OnboardingsAnalyticsEvent) {
        Log.warn("Not implemented method 'onAnalyticsEvent' of OnboardingDelegate ")
    }
}

extension OnboardingDelegate {
    func apply(message: OnboardingsMessage, from controller: UIViewController) {
        switch message {
        case let .close(action):
            onboardingController(controller, onCloseAction: action)
        case let .custom(action):
            onboardingController(controller, onCustomAction: action)
        case let .openPaywall(action):
            onboardingController(controller, onPaywallAction: action)
        case let .stateUpdated(action):
            onboardingController(controller, onStateUpdatedAction: action)
        case let .analytics(event):
            onboardingController(controller, onAnalyticsEvent: event)
        case .onboardingDidFinishLoading:
            onboardingControllerDidFinishLoading(controller)
        }
    }

    func apply(error: OnboardingsError, from controller: UIViewController) {
        onboardingController(controller, didFailWithError: error)
    }
}
