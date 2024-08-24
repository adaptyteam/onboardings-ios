
//  OnboardingsLogRecord+Codable.swift
//
//
//  Created by Aleksei Valiano on 06.08.2024
//
//

import Foundation

extension OnboardingsLog.Record: Codable {
    enum CodingKeys: String, CodingKey {
        case date
        case level
        case message
        case category
        case source = "debug_info"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try Date(timeIntervalSince1970: container.decode(Double.self, forKey: .date) / 1000.0)
        level = try container.decode(OnboardingsLog.Level.self, forKey: .level)
        message = try container.decode(String.self, forKey: .message)
        category = try container.decode(OnboardingsLog.Category.self, forKey: .category)
        source = try container.decode(OnboardingsLog.Source.self, forKey: .source)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Int64(date.timeIntervalSince1970 * 1000), forKey: .date)
        try container.encode(level, forKey: .level)
        try container.encode(message, forKey: .message)
        try container.encode(category, forKey: .category)
        try container.encode(source, forKey: .source)
    }
}
