//
//  StateUpdatedEvent.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings {
    struct StateUpdatedEvent: Sendable, Hashable {
        let clientId: String
        let meta: MetaParameters
        let params: StateUpdatedParameters

        init(_ body: BodyDecoder.Dictionary) throws {
            self.clientId = try body["cid"].asString()
            self.meta = try MetaParameters(body["meta"])

            enum ValueType: String {
                case select
                case multiSelect = "multi_select"
                case input
                case datePicker = "date_picker"
            }

            guard let valueType = try ValueType(rawValue: body["element_type"].asString()) else {
                throw BodyDecoderError.wrongValue
            }

            self.params =
                switch valueType {
                case .datePicker:
                    try .datePicker(.init(body["value"]))
                case .input:
                    try .input(.init(body["value"]))
                case .select:
                    try .select(.init(body["value"]))
                case .multiSelect:
                    try .multiSelect(
                        body["value"].asArray().map { try SelectParameters($0) }
                    )
                }
        }
    }
}

extension Onbordings.StateUpdatedEvent: CustomDebugStringConvertible {
    public var debugDescription: String {
        "{clientId: \(clientId), params: \(params.debugDescription), meta: \(meta.debugDescription)}"
    }
}
