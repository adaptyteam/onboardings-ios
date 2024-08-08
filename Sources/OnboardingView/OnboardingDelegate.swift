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
    func onboardingsCloseAction(clientId: String, withMeta: Onbordings.MetaParameters)
    func openPaywallAction(clientId: String, withMeta: Onbordings.MetaParameters)
    func customAction(clientId: String, withMeta: Onbordings.MetaParameters)
    func stateUpdated(clientId: String, params: Onbordings.StateUpdatedParameters, withMeta: Onbordings.MetaParameters)
    
    func onAnalyticsEvent(event: Onbordings.AnalyticsEvent)
    func onLoadingError(_ error: Error)
}

public protocol OnboardingSplashDelegate: NSObjectProtocol {
    func onboardingsSplashViewController() -> UIViewController?
}

public extension OnboardingDelegate {
    func openPaywallAction(clientId _: String, withMeta _: Onbordings.MetaParameters) {
        Log.warn("Not implimented method 'openPaywallAction' of  OnboardingDelegate ")
    }

    func customAction(clientId _: String, withMeta _: Onbordings.MetaParameters) {
        Log.warn("Not implimented method 'customAction' of OnboardingDelegate")
    }

    func stateUpdated(clientId _: String, params _: Onbordings.StateUpdatedParameters, withMeta _: Onbordings.MetaParameters) {
        Log.warn("Not implimented method 'stateUpdated' of OnboardingDelegate")
    }

    func onAnalyticsEvent(event _: Onbordings.AnalyticsEvent) {}
}

extension OnboardingDelegate {
    func apply(event: Onbordings.Event) {
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
