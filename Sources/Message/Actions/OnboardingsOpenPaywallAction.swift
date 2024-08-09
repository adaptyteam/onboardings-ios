//
//  OnboardingsOpenPaywallAction.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public struct OnboardingsOpenPaywallAction: Sendable, Hashable {
    public let actionId: String
    public let meta: OnboardingsMetaParams

    init(_ body: BodyDecoder.Dictionary) throws {
        self.actionId = try body["action_id"].asString()
        self.meta = try OnboardingsMetaParams(body["meta"])
    }
}

extension OnboardingsOpenPaywallAction: CustomDebugStringConvertible {
    public var debugDescription: String {
        "{actionId: \(actionId), meta: \(meta.debugDescription)}"
    }
}
