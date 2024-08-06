//
//  OctoflowsDemo_SwiftUIApp.swift
//  OctoflowsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import SwiftUI
import Octoflows

class ViewModel: ObservableObject {
    @Published var onboardingFinished = false
    
    func initialize() {
        Task {
            do {
                let configuration = try Octoflows.Configuration
                    .Builder(withAPIKey: "")
                    .with(loglevel: .verbose)
                    .build()

                try await Octoflows.activate(with: configuration)
            } catch {
                // handle the error
            }
        }
    }
}

@main
struct OctoflowsDemo_SwiftUIApp: App {
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
