//
//  Configuration.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Octoflows {
    public struct Configuration: Sendable {
        let apiKey: String
        let baseUrl: URL
        let logLevel: LogLevel
        let logHandler: LogHandler
    }
}

extension Octoflows.Configuration {
    static func createBaseUrl(apiKey: String) -> URL? {
        URL(string: "https://\(apiKey).fnlfx.com/")
    }
}


