//
//  OnboardingsDemoApp.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import Onboardings
import SwiftUI

enum Storage {
    static var customBaseUrl: String? {
        get {
            UserDefaults.standard.string(forKey: "app.baseurl")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "app.baseurl")
        }
    }

    static var onboardingId: String? {
        get {
            UserDefaults.standard.string(forKey: "app.onboarding.id")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "app.onboarding.id")
        }
    }
}

class ViewModel: ObservableObject {
    @Published var onboardingFinished = false
    @Published var onboardingURL: URL?

    @MainActor
    func initialize() {
        do {
            let configuration = OnboardingsConfiguration
                .builder(withAPIKey: "") // TODO: insert apiKey
                .with(loglevel: .verbose)

            let baseUrl = Storage.customBaseUrl ?? "https://1a.fnlfx.dev/"

            if let url = URL(string: baseUrl) {
                configuration.with(alternativeBaseUrl: url)
            }

            try Onboardings.activate(with: configuration)
        } catch {
            // handle the error
//            if let error = error as? OnboardingsError {}
        }
    }
}

@main
struct OnboardingsDemoApp: App {
    let viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ApplicationMainView()
                .environmentObject(viewModel)
        }
    }
}

struct ApplicationMainView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            ContentView()

            if !viewModel.onboardingFinished {
                Onboardings.swiftuiView(
                    id: "7-aug",
                    splashViewBuilder: {
                        SplashView()
                    },
                    onCloseAction: { _ in
                        withAnimation {
                            viewModel.onboardingFinished = true
                        }
                    },
//                    onOpenPaywallAction: { _ in
//
//                    },
//                    onCustomAction: { _ in
//
//                    },
//                    onStateUpdatedAction: { _ in
//
//                    },
//                    onAnalyticsEvent: { _ in
//
//                    },
                    onError: { _ in
                    }
                )
            }
        }
        .onAppear {
            viewModel.initialize()
        }
    }
}
