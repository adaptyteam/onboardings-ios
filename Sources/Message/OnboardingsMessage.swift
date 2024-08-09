//
//  OnboardingsMessage.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

enum OnboardingsMessage: Sendable, Hashable {
    case analytics(OnboardingsAnalyticsEvent)
    case stateUpdated(OnboardingsStateUpdatedAction)
    case openPaywall(OnboardingsOpenPaywallAction)
    case custom(OnboardingsCustomAction)
    case close(OnboardingsCloseAction)
    
    case onboardingDidFinishLoading
}

extension OnboardingsMessage: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case let .analytics(event):
            "{type: \(TypeName.analytics.rawValue), data: \(event.debugDescription)}"
        case let .stateUpdated(event):
            "{type: \(TypeName.stateUpdated.rawValue), data: \(event.debugDescription)}"
        case let .openPaywall(event):
            "{type: \(TypeName.openPaywall.rawValue), data: \(event.debugDescription)}"
        case let .custom(event):
            "{type: \(TypeName.custom.rawValue), data: \(event.debugDescription)}"
        case let .close(event):
            "{type: \(TypeName.close.rawValue), data: \(event.debugDescription)}"
        case .onboardingDidFinishLoading:
            "onboardingDidFinishLoading"
        }
    }
}
