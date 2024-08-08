//
//  Event.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Onbordings {
    enum Event: Sendable, Hashable {
        case analytics(AnalyticsEvent)
        case stateUpdated(StateUpdatedEvent)
        case openPaywall(OpenPaywallParameters)
        case custom(CustomParameters)
        case close(CloseParameters)
    }

    struct UnknownEventError: Error {
        let chanel: String
        let type: String?
    }
}

extension Onbordings.Event: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case let .analytics(event):
            "{type: \(TypeName.analytics.rawValue), data: \(event.debugDescription)}"
        case let .stateUpdated(event):
            "{type: \(TypeName.stateUpdated.rawValue), data: \(event.debugDescription)}"
        case let .openPaywall(params):
            "{type: \(TypeName.openPaywall.rawValue), data: \(params.debugDescription)}"
        case let .custom(params):
            "{type: \(TypeName.custom.rawValue), data: \(params.debugDescription)}"
        case let .close(params):
            "{type: \(TypeName.close.rawValue), data: \(params.debugDescription)}"
        }
    }
}
