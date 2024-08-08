//
//  OnboardingDelegate.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

public protocol OnboardingDelegate: NSObjectProtocol {
    func onboardingsCloseAction(clientId: String, withMeta: Onbordings.MetaParameters)
    func openPaywallAction(clientId: String, withMeta: Onbordings.MetaParameters)
    func customAction(clientId: String, withMeta: Onbordings.MetaParameters)
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
}

extension OnboardingDelegate {
    func apply(event: Onbordings.Event) {
        switch event {
        case let .close(params):
            onboardingsCloseAction(clientId: params.clientId, withMeta: params.meta)
        case let .custom(params):
            onboardingsCloseAction(clientId: params.clientId, withMeta: params.meta)
        case let .openPaywall(params):
            onboardingsCloseAction(clientId: params.clientId, withMeta: params.meta)
        case let .analytics(event):
            break
        case let .stateUpdated(event):
            break
        }
    }
}
