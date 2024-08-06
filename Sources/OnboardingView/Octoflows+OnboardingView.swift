//
//  Octoflows+OnboardingView.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

extension Octoflows {
    @MainActor
    func createOnboardingController(
        name _: String,
        delegate: OnboardingDelegate,
        onFinishLoading: @escaping (Error?) -> Void
    ) throws -> OnboardingController {
//        let url = configuration.baseUrl.appendingPathComponent(name)
        let url = URL(string: "https://x.fnlfx.com/funnel_a")!

        let vc = OnboardingController(
            url: url,
            delegate: delegate,
            onFinishLoading: onFinishLoading
        )

        return vc
    }
}
