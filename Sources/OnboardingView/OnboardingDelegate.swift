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
    func onboardingsCloseAction(clientId: String, withMeta: Onboardings.MetaParameters)
    func openPaywallAction(clientId: String, withMeta: Onboardings.MetaParameters)
    func customAction(clientId: String, withMeta: Onboardings.MetaParameters)
    func stateUpdated(clientId: String, params: Onboardings.StateUpdatedParameters, withMeta: Onboardings.MetaParameters)

    func onAnalyticsEvent(event: Onboardings.AnalyticsEvent)
    func onLoadingError(_ error: Error)
}

public protocol OnboardingSplashDelegate: NSObjectProtocol {
    func onboardingsSplashViewController() -> UIViewController?
}

public extension OnboardingDelegate {
    func openPaywallAction(clientId _: String, withMeta _: Onboardings.MetaParameters) {
        Log.warn("Not implemented method 'openPaywallAction' of  OnboardingDelegate ")
    }

    func customAction(clientId _: String, withMeta _: Onboardings.MetaParameters) {
        Log.warn("Not implemented method 'customAction' of OnboardingDelegate")
    }

    func stateUpdated(clientId _: String, params _: Onboardings.StateUpdatedParameters, withMeta _: Onboardings.MetaParameters) {
        Log.warn("Not implemented method 'stateUpdated' of OnboardingDelegate")
    }

    func onAnalyticsEvent(event _: Onboardings.AnalyticsEvent) {}
}

extension OnboardingDelegate {
    func apply(message: Onboardings.Message) {
        switch message {
        case let .close(action):
            onboardingsCloseAction(clientId: action.clientId, withMeta: action.meta)
        case let .custom(action):
            onboardingsCloseAction(clientId: action.clientId, withMeta: action.meta)
        case let .openPaywall(action):
            onboardingsCloseAction(clientId: action.clientId, withMeta: action.meta)
        case let .stateUpdated(action):
            stateUpdated(clientId: action.clientId, params: action.params, withMeta: action.meta)
        case let .analytics(event):
            onAnalyticsEvent(event: event)
        }
    }

    func apply(error: Error) {
        onLoadingError(error)
    }
}
