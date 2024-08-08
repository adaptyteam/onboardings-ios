//
//  OnboArdings+OnboardingView.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import UIKit

extension Onboardings {
    @MainActor
    func createOnboardingController(
        id: String,
        delegate: OnboardingDelegate,
        onFinishLoading: @escaping () -> Void
    ) throws -> OnboardingController {
        let url = configuration.onboardingUrl(onboardingId: id)

        let vc = OnboardingController(
            url: url,
            delegate: delegate,
            onFinishLoading: onFinishLoading
        )

        return vc
    }
}
