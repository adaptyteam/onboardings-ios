//
//  Configuration.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Octoflows {
    public struct Configuration: Sendable, Hashable {
        static let `default` = Configuration(
            apiKey: ""
        )

        let apiKey: String
    }
}

extension Octoflows.Configuration: Decodable {
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        apiKey = try container.decode(String.self, forKey: .apiKey)
    }
}
