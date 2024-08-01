//
//  Octoflows+IntroView.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Octoflows {
    func getInroView(name: String) async throws -> OctoflowsIntroView.Configuration {
        .init(url: baseUrl.appendingPathComponent(name))
    }
}
