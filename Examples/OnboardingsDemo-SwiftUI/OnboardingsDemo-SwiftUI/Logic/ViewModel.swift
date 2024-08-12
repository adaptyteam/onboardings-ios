//
//  ViewModel.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 12.08.2024.
//

import Foundation
import Onboardings

class ViewModel: ObservableObject {
    @Published var customBaseUrl: String = Storage.customBaseUrl ?? "https://1a.fnlfx.dev/"
    @Published var onboardingId: String = Storage.onboardingId ?? "7-aug"
    
    
    @Published var onboardingFinished = false

    var onError: ((Error) -> Void)?

    @MainActor
    func initialize() {
        do {
            let configuration = OnboardingsConfiguration
                .builder(withAPIKey: "YOUR_API_KEY")
                .with(loglevel: .verbose)

            if let url = URL(string: customBaseUrl) {
                configuration.with(alternativeBaseUrl: url)
            }

            try Onboardings.activate(with: configuration)
        } catch {
            onError?(error)
        }
    }
    
    var hasChanges: Bool {
        onboardingId != Storage.onboardingId ?? "" ||
            customBaseUrl != Storage.customBaseUrl ?? ""
    }
    
    func saveCustomData() {
        Storage.setCustomBaseUrl(customBaseUrl.isEmpty ? nil : customBaseUrl)
        Storage.setOnboardingId(onboardingId.isEmpty ? nil : onboardingId)
        
        
        customBaseUrl = Storage.customBaseUrl ?? "https://1a.fnlfx.dev/"
        onboardingId = Storage.onboardingId ?? "7-aug"
    }
}
