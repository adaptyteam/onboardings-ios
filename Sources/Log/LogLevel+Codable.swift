//
//  LogLevel+Codable.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Onbordings.LogLevel: Codable {
    public init(from decoder: Decoder) throws {
        self = try Onbordings.LogLevel(stringLiteral: decoder.singleValueContainer().decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringLiteral)
    }
}
