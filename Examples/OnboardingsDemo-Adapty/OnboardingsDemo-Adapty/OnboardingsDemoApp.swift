//
//  OnboardingsDemoApp.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import SwiftUI

@main
struct OnboardingsDemoApp: App {
    let viewModel: ViewModel

    init() {
        viewModel = ViewModel()
        viewModel.initialize()
    }

    var body: some Scene {
        WindowGroup {
            ApplicationMainView()
                .environmentObject(viewModel)
        }
    }
}
