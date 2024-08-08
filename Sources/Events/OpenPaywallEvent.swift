//
//  OpenPaywallEvent.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onboardings {
    struct OpenPaywallEvent: Sendable, Hashable {
        let clientId: String
        let meta: MetaParameters

        init(_ body: BodyDecoder.Dictionary) throws {
            self.clientId = try body["id"].asString()
            self.meta = try MetaParameters(body["meta"])
        }
    }
}

extension Onboardings.OpenPaywallEvent: CustomDebugStringConvertible {
    var debugDescription: String {
        "{clientId: \(clientId), meta: \(meta.debugDescription)}"
    }
}
