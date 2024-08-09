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

    var onError: ((Error) -> Void)?

    @MainActor
    func initialize() {
        do {
            let configuration = OnboardingsConfiguration
                .builder(withAPIKey: "YOUR_API_KEY")
                .with(loglevel: .verbose)

            let baseUrl = Storage.customBaseUrl ?? "https://1a.fnlfx.dev/"

            if let url = URL(string: baseUrl) {
                configuration.with(alternativeBaseUrl: url)
            }

            try Onboardings.activate(with: configuration)
        } catch {
            onError?(error)
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

struct IdentifiableErrorWrapper: Identifiable {
    var id: String = UUID().uuidString
    var value: Error
}

struct ApplicationMainView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State var errorAlert: IdentifiableErrorWrapper?

    var body: some View {
        ZStack {
            NavigationView {
                ContentView()
            }

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
                    onError: { error in
                        errorAlert = .init(value: error)
                    }
                )

                Button("Force Skip") {
                    viewModel.onboardingFinished = true
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .onAppear {
            viewModel.onError = { error in
                errorAlert = .init(value: error)
            }
            viewModel.initialize()
        }
        .alert(item: $errorAlert) { error in
            Alert(
                title: Text("Error!"),
                message: Text(error.value.localizedDescription),
                dismissButton: .cancel()
            )
        }
    }
}
