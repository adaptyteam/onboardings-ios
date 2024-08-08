//
//  Configuration.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Onboardings {
    public struct Configuration: Sendable {
        let apiKey: String
        let baseUrl: URL
        let logLevel: LogLevel
        let logHandler: LogHandler
    }
}

extension Onboardings.Configuration {
    static func createBaseUrl(apiKey: String) -> URL? {
        URL(string: "https://\(apiKey).fnlfx.com/")
    }

    func onboardingUrl(onboardingId id: String) -> URL {
        baseUrl.appendingPathComponent(id)
    }
}

extension Onboardings.Configuration: CustomDebugStringConvertible {
    public var debugDescription: String {
        "{baseUrl: \(baseUrl.absoluteString), logLevel: \(logLevel.description)}"
    }
}
