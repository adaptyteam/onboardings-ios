//
//  OctoflowsDemo_SwiftUIApp.swift
//  OctoflowsDemo-SwiftUI
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
        } catch let error as OnbordingsError {
            // handle the error
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
