//
//  OnboardingsConfiguration.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public struct OnboardingsConfiguration: Sendable {
    let apiKey: String
    let baseUrl: URL
    let logLevel: OnboardingsLog.Level
    let logHandler: OnboardingsLog.Handler?
}

extension OnboardingsConfiguration {
    static func createBaseUrl(apiKey: String) -> URL? {
        URL(string: "https://\(apiKey).octopusbuilder.com/")
    }

    func onboardingUrl(onboardingId id: String) -> URL {
        baseUrl.appendingPathComponent(id)
    }
}

extension OnboardingsConfiguration: CustomDebugStringConvertible {
    public var debugDescription: String {
        "{baseUrl: \(baseUrl.absoluteString), logLevel: \(logLevel.description), logHandler: \(logHandler == nil ? "nil" : "defined")}"
    }
}
