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
            var configurationBuilder = Onboardings.Configuration
                .Builder(withAPIKey: "") // TODO: insert apiKey
                .with(loglevel: .verbose)

            let baseUrl = Storage.customBaseUrl ?? "https://1a.fnlfx.dev/"

            if let url = URL(string: baseUrl) {
                configurationBuilder = configurationBuilder.with(alternativeBaseUrl: url)
            }

            try Onboardings.activate(with: try configurationBuilder.build())

            loadData()
        } catch {
            // handle the error
            if let error = error as? OnboardingsError {}
        }
    }

    private func loadData() {
        Task { @MainActor in
            do {
                onboardingURL = try await Onboardings.getOnboardingURL(id: Storage.onboardingId ?? "7-aug")
                print("")
            } catch {
                // handle the error
                if let error = error as? OnboardingsError {}
            }
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

            splashOrOnboardingView
        }
        .onAppear {
            viewModel.initialize()
        }
    }

    @ViewBuilder
    private var splashOrOnboardingView: some View {
        if !viewModel.onboardingFinished, let url = viewModel.onboardingURL {
            OnboardingSplashView(
                url: url,
                splashViewBuilder: {
                    SplashView()
                },
                onCloseAction: { _ in
                    withAnimation {
                        viewModel.onboardingFinished = true
                    }
                },
                onOpenPaywallAction: { _ in

                },
                onCustomAction: { _ in

                },
                onStateUpdatedAction: { _ in

                },
                onAnalyticsEvent: { _ in

                },
                onLoadingError: { _ in
                }
            )
        } else if !viewModel.onboardingFinished {
            SplashView()
        }
    }
}
