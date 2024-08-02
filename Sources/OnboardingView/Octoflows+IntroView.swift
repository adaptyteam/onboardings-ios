//
//  Octoflows+OnboardingView.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Octoflows {
    func getOnboardingView(name: String) async throws -> OctoflowsOnboardingView.Configuration {
        .init(url: configuration.baseUrl.appendingPathComponent(name))
    }
}
