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
    func apply(event: Onboardings.Event) {
        switch event {
        case let .close(event):
            onboardingsCloseAction(clientId: event.clientId, withMeta: event.meta)
        case let .custom(event):
            onboardingsCloseAction(clientId: event.clientId, withMeta: event.meta)
        case let .openPaywall(event):
            onboardingsCloseAction(clientId: event.clientId, withMeta: event.meta)
        case let .stateUpdated(event):
            stateUpdated(clientId: event.clientId, params: event.params, withMeta: event.meta)
        case let .analytics(event):
            onAnalyticsEvent(event: event)
        }
    }

    func apply(error: Error) {
        onLoadingError(error)
    }
}
