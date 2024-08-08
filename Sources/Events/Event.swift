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
        case openPaywall(OpenPaywallEvent)
        case custom(CustomEvent)
        case close(CloseEvent)
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
        case let .openPaywall(event):
            "{type: \(TypeName.openPaywall.rawValue), data: \(event.debugDescription)}"
        case let .custom(event):
            "{type: \(TypeName.custom.rawValue), data: \(event.debugDescription)}"
        case let .close(event):
            "{type: \(TypeName.close.rawValue), data: \(event.debugDescription)}"
        }
    }
}
