//
//  StateUpdatedParameters.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings {
    public enum StateUpdatedParameters: Sendable, Hashable {
        case select(SelectParameters)
        case multiSelect([SelectParameters])
        case input(InputParameters)
        case datePicker(DatePickerParameters)
    }

    public struct SelectParameters: Sendable, Hashable {
        public let id: String
        public let value: String
        public let label: String

        init(_ body: BodyDecoder.Value) throws {
            let body = try body.asDictionary()
            self.id = try body["id"].asString()
            self.value = try body["value"].asString()
            self.label = try body["label"].asString()
        }
    }

    public enum InputParameters: Sendable, Hashable {
        case text(String)
        case email(String)
        case number(Double)

        init(_ body: BodyDecoder.Value) throws {
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

    public struct DatePickerParameters: Sendable, Hashable {
        public let day: Int
        public let month: Int
        public let year: Int

        init(_ body: BodyDecoder.Value) throws {
            let body = try body.asDictionary()
            self.day = try body["day"].asInt()
            self.month = try body["month"].asInt()
            self.year = try body["year"].asInt()
        }
    }
}

extension Onbordings.StateUpdatedParameters: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .select(params):
            params.debugDescription
        case let .multiSelect(array):
            "[\(array.map { $0.debugDescription }.joined(separator: ", "))]"
        case let .input(params):
            params.debugDescription
        case let .datePicker(params):
            params.debugDescription
        }
    }
}

extension Onbordings.SelectParameters: CustomDebugStringConvertible {
    public var debugDescription: String {
        "{id: \(id), value: \(value), label: \(label)}"
    }
}

extension Onbordings.InputParameters: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .text(value):
            "{text: \(value)}"
        case let .email(value):
            "{email: \(value)}"
        case let .number(value):
            "{number: \(value)}"
        }
    }
}

extension Onbordings.DatePickerParameters: CustomDebugStringConvertible {
    public var debugDescription: String {
        "{day: \(day), month: \(month), year: \(year)}"
    }
}
