//
//  Event.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Onbordings {
    public enum Event: Sendable, Hashable {
        case stateUpdated(StateUpdatedParameters)
    }

    typealias PublicEvent = Event

    enum PrivateEvent: Sendable, Hashable {
        case openPaywall(OpenPaywallParameters)
        case custom(CustomParameters)
        case close(CloseParameters)
    }

    enum RawEvent: Sendable, Hashable {
        case `public`(PublicEvent)
        case `private`(PrivateEvent)
    }

    struct UnknownEventError: Error {
        let chanel: String
        let type: String?
    }
}
