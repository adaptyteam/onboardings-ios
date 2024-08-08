//
//  Message.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Onboardings {
    enum Message: Sendable, Hashable {
        case analytics(AnalyticsEvent)
        case stateUpdated(StateUpdatedAction)
        case openPaywall(OpenPaywallAction)
        case custom(CustomAction)
        case close(CloseAction)
    }

    struct UnknownMessageError: Error {
        let chanel: String
        let type: String?
    }
}

extension Onboardings.Message: CustomDebugStringConvertible {
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
