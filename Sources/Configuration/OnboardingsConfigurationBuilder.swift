//
//  OnboardingsConfigurationBuilder.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension OnboardingsConfiguration {
    fileprivate init(with builder: OnboardingsConfigurationBuilder) throws {
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

    public static func builder(withAPIKey apiKey: String) -> OnboardingsConfigurationBuilder {
        .init(withAPIKey: apiKey)
    }
}

public final class OnboardingsConfigurationBuilder {
    public private(set) var apiKey: String
    public private(set) var alternativeBaseUrl: URL?
    public private(set) var logLevel: OnboardingsLog.Level
    public private(set) var logHandler: OnboardingsLog.Handler?

    public convenience init(withAPIKey key: String) {
        self.init(
            apiKey: key,
            alternativeBaseUrl: nil,
            logLevel: .default,
            logHandler: nil
        )
    }

    init(
        apiKey: String,
        alternativeBaseUrl: URL? = nil,
        logLevel: OnboardingsLog.Level,
        logHandler: OnboardingsLog.Handler?
    ) {
        self.apiKey = apiKey
        self.alternativeBaseUrl = alternativeBaseUrl
        self.logLevel = logLevel
        self.logHandler = logHandler
    }

    /// Call this method to get the ``Onboardings.Configuration`` object.
    public func build() throws -> OnboardingsConfiguration {
        try .init(with: self)
    }
}

extension OnboardingsConfigurationBuilder: Decodable {
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
            logLevel: container.decode(OnboardingsLog.Level.self, forKey: .logLevel),
            logHandler: nil
        )
    }
}

extension OnboardingsConfigurationBuilder {
    @discardableResult
    public func with(apiKey key: String) -> Self {
        apiKey = key
        return self
    }

    @discardableResult
    public func with(alternativeBaseUrl url: URL?) -> Self {
        alternativeBaseUrl = url
        return self
    }

    @discardableResult
    public func with(loglevel level: OnboardingsLog.Level) -> Self {
        logLevel = level
        return self
    }

    @discardableResult
    public func with(logHandler handler: OnboardingsLog.Handler?) -> Self {
        logHandler = handler
        return self
    }
}
