//
//  OnboardingDelegate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

// TODO: refactor namings
public protocol OnboardingDelegate: NSObjectProtocol {
    func onboardingsCloseAction(_ action: OnboardingsCloseAction)
    func openPaywallAction(_ action: OnboardingsOpenPaywallAction)
    func customAction(_ action: OnboardingsCustomAction)
    func stateUpdatedAction(_ action: OnboardingsStateUpdatedAction)

    func onAnalyticsEvent(_ event: OnboardingsAnalyticsEvent)
    func onLoadingError(_ error: Error)
}

public protocol OnboardingSplashDelegate: NSObjectProtocol {
    func onboardingsSplashViewController() -> UIViewController?
}

public extension OnboardingDelegate {
    func openPaywallAction(_: OnboardingsOpenPaywallAction) {
        Log.warn("Not implemented method 'openPaywallAction' of  OnboardingDelegate ")
    }

    func customAction(_: OnboardingsCustomAction) {
        Log.warn("Not implemented method 'customAction' of OnboardingDelegate")
    }

    func stateUpdatedAction(_: OnboardingsStateUpdatedAction) {
        Log.warn("Not implemented method 'stateUpdated' of OnboardingDelegate")
    }

    func onAnalyticsEvent(_: OnboardingsAnalyticsEvent) {}
}

extension OnboardingDelegate {
    func apply(message: OnboardingsMessage) {
        switch message {
        case let .close(action):
            onboardingsCloseAction(action)
        case let .custom(action):
            customAction(action)
        case let .openPaywall(action):
            openPaywallAction(action)
        case let .stateUpdated(action):
            stateUpdatedAction(action)
        case let .analytics(event):
            onAnalyticsEvent(event)
        }
    }

    func apply(error: Error) {
        onLoadingError(error)
    }
}
