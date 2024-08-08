//
//  Configuration.Builder.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Onboardings.Configuration {
    init(with builder: Builder) throws {
        let apiKey = builder.apiKey
        guard let baseUrl = builder.alternativeBaseUrl ?? Self.createBaseUrl(apiKey: apiKey) else {
            throw OnboardingsError.wrongApiKey(description: "unable to create baseUrl.")
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
        public private(set) var logLevel: Onboardings.LogLevel
        public private(set) var logHandler: Onboardings.LogHandler

        public convenience init(withAPIKey key: String) {
            self.init(
                apiKey: key,
                alternativeBaseUrl: nil,
                logLevel: .default,
                logHandler: Onboardings.defaultLogHandler
            )
        }

        init(
            apiKey: String,
            alternativeBaseUrl: URL? = nil,
            logLevel: Onboardings.LogLevel,
            logHandler: @escaping Onboardings.LogHandler
        ) {
            self.apiKey = apiKey
            self.alternativeBaseUrl = alternativeBaseUrl
            self.logLevel = logLevel
            self.logHandler = logHandler
        }

        /// Call this method to get the ``Onboardings.Configuration`` object.
        public func build() throws -> Onboardings.Configuration {
            try .init(with: self)
        }
    }
}

extension Onboardings.Configuration.Builder: Decodable {
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
            logLevel: container.decode(Onboardings.LogLevel.self, forKey: .logLevel),
            logHandler: Onboardings.defaultLogHandler
        )
    }
}

extension Onboardings.Configuration.Builder {
    public func with(apiKey key: String) -> Self {
        apiKey = key
        return self
    }

    public func with(alternativeBaseUrl url: URL?) -> Self {
        alternativeBaseUrl = url
        return self
    }

    public func with(loglevel level: Onboardings.LogLevel) -> Self {
        logLevel = level
        return self
    }

    public func with(logHandler handler: @escaping Onboardings.LogHandler) -> Self {
        logHandler = handler
        return self
    }
}
