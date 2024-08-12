//
//  ViewModel.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 12.08.2024.
//

import Adapty
import Foundation
import Onboardings

class ViewModel: ObservableObject {
    @Published var onboardingIdLoading = true
    @Published var onboardingId: String?

    var onError: ((Error) -> Void)?

    @MainActor
    func initialize() {
        Adapty.activate("public_live_QzY2YBrm.j0U3MNaKe2HAgeK4XV13")

        do {
            let configuration = OnboardingsConfiguration
                .builder(withAPIKey: "YOUR_API_KEY")
                .with(loglevel: .verbose)
                .with(alternativeBaseUrl: URL(string: "https://1a.fnlfx.dev/"))

            try Onboardings.activate(with: configuration)
        } catch {
            onError?(error)
        }
    }

    func loadOnboardingId() {
        Task { @MainActor in
            do {
                let paywall = try await Adapty.getPaywall(placementId: "onboarding-id")

                if let onboardingId = paywall.remoteConfig?.dictionary?["onboarding-id"] as? String {
                    self.onboardingId = onboardingId
                }
            } catch {
                onError?(error)
            }
        }
    }

    func setOnboardingFinished() {
        onboardingId = nil
    }
}
