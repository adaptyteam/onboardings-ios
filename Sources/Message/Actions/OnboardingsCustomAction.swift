//
//  OnboardingsCustomAction.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public struct OnboardingsCustomAction: Sendable, Hashable {
    public let clientId: String
    public let meta: OnboardingsMetaParams

    init(_ body: BodyDecoder.Dictionary) throws {
        self.clientId = try body["id"].asString()
        self.meta = try OnboardingsMetaParams(body["meta"])
    }
}

extension OnboardingsCustomAction: CustomDebugStringConvertible {
    public var debugDescription: String {
        "{clientId: \(clientId), meta: \(meta.debugDescription)}"
    }
}
