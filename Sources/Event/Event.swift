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
        case showPaywall(ShowPaywallParameters)
        case example(ExampleParameters)
    }

    typealias PublicEvent = Event

    enum PrivateEvent: Sendable, Hashable {
        case example(ExampleParameters)
    }
}

extension Onbordings {
    private enum RawEventName: String {
        case close
        case showPaywall = "show_paywall"
        case example
        case privateExample = "private_example"
    }

    enum RawEvent: Sendable, Hashable {
        case `public`(PublicEvent)
        case `private`(PrivateEvent)
        case unknown(name: String)

        init(name: String, body: Any) throws {
            switch RawEventName(rawValue: name) {
            case .close:
                self = try .public(.close(.init(body)))
            case .showPaywall:
                self = try .public(.showPaywall(.init(body)))
            case .example:
                self = try .public(.example(.init(body)))
            case .privateExample:
                self = try .private(.example(.init(body)))
            default:
                self = .unknown(name: name)
            }
        }
    }
}
