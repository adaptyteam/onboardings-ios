//
//  Event+Decoder.swift
//
//
//  Created by Aleksei Valiano on 07.08.2024
//
//

import Foundation

extension Onbordings.RawEvent {
    init(chanel: String, body: Any) throws {
//        enum ChanelName: String {
//            case events
//        }
//
//        switch ChanelName(rawValue: chanel) {
//        case .none:
//            let body = try? BodyDecoder.decode(body).asOptionalDictionary()
//            let type = try? body?["type"].asOptionalString()
//            throw Onbordings.UnknownEventError(chanel: chanel, type: type)
//        case .events:
        try self.init(chanel, eventBody: body)
//        }
    }

    private init(_ chanel: String, eventBody body: Any) throws {
        let body = try BodyDecoder.decode(body).asDictionary()
        let type = try body["type"].asString()

        enum TypeName: String {
            case close
            case openPaywall = "open_paywall"
            case custom
            case stateUpdated = "state_updated"
            case analytics
        }

        switch TypeName(rawValue: type) {
        case .none:
            throw Onbordings.UnknownEventError(chanel: chanel, type: type)
        case .analytics:
            self = try .public(.analytics(.init(body)))
        case .stateUpdated:
            self = try .public(.stateUpdated(.init(body)))
        case .close:
            self = try .private(.close(.init(body)))
        case .openPaywall:
            self = try .private(.openPaywall(.init(body)))
        case .custom:
            self = try .private(.custom(.init(body)))
        }
    }
}
