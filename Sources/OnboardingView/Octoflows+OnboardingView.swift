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
        name: String,
        delegate: OnboardingSplashDelegate
    ) throws -> UIViewController {
        let url = configuration.baseUrl.appendingPathComponent(name)
        //        OctoflowsOnboardingViewController(url: <#T##URL#>)
        //        UIViewController()
        let vc = OnboardingSplashController(
            url: url,
            delegate: delegate
        )

        return vc
    }
}
