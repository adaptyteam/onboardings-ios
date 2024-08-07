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
        case close(CloseParameters)
        case openPaywall(OpenPaywallParameters)
        case custom(CustomParameters)
        case stateUpdated(StateUpdatedParameters)
    }

    typealias PublicEvent = Event

    enum PrivateEvent: Sendable, Hashable {
        case example
    }

    enum RawEvent: Sendable, Hashable {
        case `public`(PublicEvent)
        case `private`(PrivateEvent)
        case unknown(chanel: String, type: String?)
    }
}
