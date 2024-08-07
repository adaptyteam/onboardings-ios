//
//  Onbordings+OnboardingView.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

extension Onbordings {
    @MainActor
    func createOnboardingController(
        name: String,
        delegate: OnboardingDelegate,
        onFinishLoading: @escaping (Error?) -> Void
    ) throws -> OnboardingController {
        let url = configuration.baseUrl.appendingPathComponent(name)

        let vc = OnboardingController(
            url: url,
            delegate: delegate,
            onFinishLoading: onFinishLoading
        )

        return vc
    }
}
