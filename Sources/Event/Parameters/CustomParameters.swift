//
//  CustomParameters.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings {
    public struct CustomParameters: Sendable, Hashable {
        public let clientId: String
        public let meta: MetaParameters

        init(_ body: BodyDecoder.Dictionary) throws {
            self.clientId = try body["cid"].asString()
            self.meta = try MetaParameters(body["meta"])
        }
    }
}
