//
//  OnboardingsDemoApp.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import SwiftUI
import Onbordings

class ViewModel: ObservableObject {
    @Published var onboardingFinished = false
    
    @MainActor
    func initialize() {
        do {
            let configuration = try Onbordings.Configuration
                .Builder(withAPIKey: "") // TODO: insert apiKey
                .with(alternativeBaseUrl: URL(string: "https://x.fnlfx.com/")! ) // TODO: remove
                .with(loglevel: .verbose)
                .build()

            try Onbordings.activate(with: configuration)
        } catch {
            // handle the error
            if let error = error as? OnbordingsError {
                
            }
        }
    }
    
}

@main
struct OnboardingsDemoApp: App {
    let viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                
                if !viewModel.onboardingFinished {
                    OnboardingSplashView {
                        SplashView()
                    }
                }
            }
            .onAppear {
                viewModel.initialize()
            }
        }
    }
}
