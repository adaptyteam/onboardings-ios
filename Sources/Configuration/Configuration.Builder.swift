//
//  Configuration.Builder.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Onbordings.Configuration {
    init(with builder: Builder) throws {
        let apiKey = builder.apiKey
        guard let baseUrl = builder.alternativeBaseUrl ?? Self.createBaseUrl(apiKey: apiKey) else {
            throw OnbordingsError.wrongApiKey(description: "unable to create baseUrl.")
        }

        self.init(
            apiKey: apiKey,
            baseUrl: baseUrl,
            logLevel: builder.logLevel,
            logHandler: builder.logHandler
        )
    }

    public static func builder(withAPIKey apiKey: String) -> Builder {
        .init(withAPIKey: apiKey)
    }

    public final class Builder {
        public private(set) var apiKey: String
        public private(set) var alternativeBaseUrl: URL?
        public private(set) var logLevel: Onbordings.LogLevel
        public private(set) var logHandler: Onbordings.LogHandler

        public convenience init(withAPIKey key: String) {
            self.init(
                apiKey: key,
                alternativeBaseUrl: nil,
                logLevel: .default,
                logHandler: Onbordings.defaultLogHandler
            )
        }

        init(
            apiKey: String,
            alternativeBaseUrl: URL? = nil,
            logLevel: Onbordings.LogLevel,
            logHandler: @escaping Onbordings.LogHandler
        ) {
            self.apiKey = apiKey
            self.alternativeBaseUrl = alternativeBaseUrl
            self.logLevel = logLevel
            self.logHandler = logHandler
        }

        /// Call this method to get the ``Onbordings.Configuration`` object.
        public func build() throws -> Onbordings.Configuration {
            try .init(with: self)
        }
    }
}

extension Onbordings.Configuration.Builder: Decodable {
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case alternativeBaseUrl = "base_url"
        case logLevel = "log_level"
    }

    public convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        try self.init(
            apiKey: container.decode(String.self, forKey: .apiKey),
            alternativeBaseUrl: container.decodeIfPresent(URL.self, forKey: .alternativeBaseUrl),
            logLevel: container.decode(Onbordings.LogLevel.self, forKey: .logLevel),
            logHandler: Onbordings.defaultLogHandler
        )
    }
}

extension Onbordings.Configuration.Builder {
    public func with(apiKey key: String) -> Self {
        apiKey = key
        return self
    }

    public func with(alternativeBaseUrl url: URL?) -> Self {
        alternativeBaseUrl = url
        return self
    }

    public func with(loglevel level: Onbordings.LogLevel) -> Self {
        logLevel = level
        return self
    }

    public func with(logHandler handler: @escaping Onbordings.LogHandler) -> Self {
        logHandler = handler
        return self
    }
}
