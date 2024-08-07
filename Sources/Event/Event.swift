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
    }

    typealias PublicEvent = Event

    enum PrivateEvent: Sendable, Hashable {
        case example(ExampleParameters)
    }
}

extension Onbordings {
    private enum EventChanelName: String {
        case analytics
        case event
    }

    private enum AnalyticsTypeName: String {
        case test
    }

    private enum EventTypeName: String {
        case close
        case openPaywall = "open_paywall"
        case custom
    }

    enum RawEvent: Sendable, Hashable {
        case `public`(PublicEvent)
        case `private`(PrivateEvent)
        case unknown(chanel: String, type: String?)

        init(chanel: String, body: Any) throws {
            switch EventChanelName(rawValue: chanel) {
            case .none:
                let body = try? BodyDecoder.decode(body).asOptionalDictionary()
                let type = try? body?["type"].asOptionalString()
                self = .unknown(chanel: chanel, type: type)
            case .analytics:
                self = try RawEvent(chanel, analyticsBody: body)
            case .event:
                self = try RawEvent(chanel, eventBody: body)
            }
        }

        private init(_ chanel: String, analyticsBody body: Any) throws {
            let body = try BodyDecoder.decode(body).asDictionary()
            let type = try body["type"].asString()

            switch AnalyticsTypeName(rawValue: type) {
            case .none:
                self = .unknown(chanel: chanel, type: type)
            case .test:
                self = .unknown(chanel: chanel, type: type)
            }
        }

        private init(_ chanel: String, eventBody body: Any) throws {
            let body = try BodyDecoder.decode(body).asDictionary()
            let type = try body["type"].asString()

            switch EventTypeName(rawValue: type) {
            case .none:
                self = .unknown(chanel: chanel, type: type)
            case .close:
                self = try .public(.close(.init(body)))
            case .openPaywall:
                self = try .public(.openPaywall(.init(body)))
            case .custom:
                self = try .public(.custom(.init(body)))
            }
        }
    }
}
