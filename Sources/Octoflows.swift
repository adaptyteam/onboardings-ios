//
//  Octoflows.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public actor Octoflows {
    static var shared: Octoflows?

    let baseUrl: URL

    init(configuration: Configuration) throws {
        guard let baseUrl = configuration.baseUrl else {
            throw OctoflowsError.wrongApiKey(description: "unable to create baseUrl.")
        }

        self.baseUrl = baseUrl
    }
}


