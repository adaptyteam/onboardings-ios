//
//  PublicEvent+Custom.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings.PublicEvent {
    public struct CustomParameters: Sendable, Hashable {
        let clientId: String
        let meta: MetaParameters

        init(_ body: BodyDecoder.Dictionary) throws {
            self.clientId = try body["cid"].asString()
            self.meta = try MetaParameters(body["meta"])
        }
    }
}
