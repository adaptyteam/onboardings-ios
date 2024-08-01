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
            apiKey: "",
            alternativeBaseUrl: nil
        )

        let apiKey: String
        let alternativeBaseUrl: URL?
    }
}

extension Octoflows.Configuration {
    var baseUrl: URL? {
        if let url = alternativeBaseUrl { return url }
        return URL(string: "https://\(apiKey).fnlfx.com/")
    }
}

extension Octoflows.Configuration: Decodable {
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case alternativeBaseUrl = "base_url"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        apiKey = try container.decode(String.self, forKey: .apiKey)
        alternativeBaseUrl = try container.decodeIfPresent(URL.self, forKey: .alternativeBaseUrl)
    }
}
