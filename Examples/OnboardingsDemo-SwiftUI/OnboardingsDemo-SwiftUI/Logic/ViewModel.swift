//
//  ViewModel.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 12.08.2024.
//

import Foundation
import Onboardings

class ViewModel: ObservableObject {
    @Published var onboardingFinished = false

    var onError: ((Error) -> Void)?

    @MainActor
    func initialize() {
        do {
            let configuration = OnboardingsConfiguration
                .builder(withAPIKey: "YOUR_API_KEY")
                .with(loglevel: .verbose)

            try Onboardings.activate(with: configuration)
        } catch {
            onError?(error)
        }
    }
}
