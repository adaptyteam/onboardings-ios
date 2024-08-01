//
//  Configuration.Builder.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Octoflows.Configuration {
    init(with builder: Builder) {
        self.init(
            apiKey: builder.apiKey,
            alternativeBaseUrl: builder.alternativeBaseUrl
        )
    }

    public static func builder(withAPIKey apiKey: String) -> Builder {
        .init(withAPIKey: apiKey)
    }

    public final class Builder {
        public private(set) var apiKey: String
        public private(set) var alternativeBaseUrl: URL?

        public convenience init(withAPIKey key: String) {
            self.init(Octoflows.Configuration.default)
            apiKey = key
        }

        init(_ configuration: Octoflows.Configuration) {
            self.apiKey = configuration.apiKey
        }

        /// Call this method to get the ``Octoflows.Configuration`` object.
        public func build() -> Octoflows.Configuration { .init(with: self) }

        public func with(apiKey key: String) -> Builder {
            apiKey = key
            return self
        }

        public func with(alternativeBaseUrl url: URL?) -> Builder {
            alternativeBaseUrl = url
            return self
        }
    }
}
