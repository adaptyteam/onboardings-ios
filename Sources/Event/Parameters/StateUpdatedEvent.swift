//
//  StateUpdatedEvent.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings {
    public struct StateUpdatedEvent: Sendable, Hashable {
        public let clientId: String
        public let meta: MetaParameters
        public let value: Value

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

            self.value =
                switch valueType {
                case .datePicker:
                    try .datePicker(.init(body["value"]))
                case .input:
                    try .input(.init(body["value"]))
                case .select:
                    try .select(.init(body["value"]))
                case .multiSelect:
                    try .multiSelect(
                        body["value"].asArray().map { try SelectValue($0) }
                    )
                }
        }
    }
}

extension Onbordings.StateUpdatedEvent {
    public enum Value: Sendable, Hashable {
        case select(SelectValue)
        case multiSelect([SelectValue])
        case input(InputValue)
        case datePicker(DatePickerValue)
    }

    public struct SelectValue: Sendable, Hashable {
        public let id: String
        public let value: String
        public let label: String

        fileprivate init(_ body: BodyDecoder.Value) throws {
            let body = try body.asDictionary()
            self.id = try body["id"].asString()
            self.value = try body["value"].asString()
            self.label = try body["label"].asString()
        }
    }

    public enum InputValue: Sendable, Hashable {
        case text(String)
        case email(String)
        case number(Double)

        fileprivate init(_ body: BodyDecoder.Value) throws {
            let body = try body.asDictionary()

            enum ValueType: String {
                case text
                case email
                case number
            }

            guard let valueType = try ValueType(rawValue: body["type"].asString()) else {
                throw BodyDecoderError.wrongValue
            }

            self =
                switch valueType {
                case .text:
                    try .text(body["value"].asString())
                case .email:
                    try .email(body["value"].asString())
                case .number:
                    try .number(body["value"].asDouble())
                }
        }
    }

    public struct DatePickerValue: Sendable, Hashable {
        public let day: Int
        public let month: Int
        public let year: Int

        fileprivate init(_ body: BodyDecoder.Value) throws {
            let body = try body.asDictionary()
            self.day = try body["day"].asInt()
            self.month = try body["month"].asInt()
            self.year = try body["year"].asInt()
        }
    }
}
