//
//  CustomEvent.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings {
    struct CustomEvent: Sendable, Hashable {
        let clientId: String
        let meta: MetaParameters

        init(_ body: BodyDecoder.Dictionary) throws {
            self.clientId = try body["cid"].asString()
            self.meta = try MetaParameters(body["meta"])
        }
    }
}

extension Onbordings.CustomEvent: CustomDebugStringConvertible {
    var debugDescription: String {
        "{clientId: \(clientId), meta: \(meta.debugDescription)}"
    }
}
