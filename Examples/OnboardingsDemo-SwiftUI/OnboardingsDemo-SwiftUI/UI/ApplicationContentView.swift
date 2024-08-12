//
//  ApplicationContentView.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import SwiftUI

struct ApplicationContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        List {
            Section {
                TextField("Enter URL", text: $viewModel.customBaseUrl)
            } header: {
                Text("Override Base URL")
            } footer: {
                Text("Reload the application to apply changes")
            }

            Section {
                TextField("Enter Onboarding Id", text: $viewModel.onboardingId)
            } header: {
                Text("Override Onboarding Id")
            } footer: {
                Text("Press 'Logout' to apply changes")
            }

            Section {
                Button {
                    withAnimation {
                        viewModel.onboardingFinished = false
                    }
                } label: {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.saveCustomData()
                } label: {
                    Text("Save")
                        .bold()
                }
                .disabled(!viewModel.hasChanges)
            }
        }
        .navigationTitle("Welcome to Onboardings SDK!")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ApplicationContentView()
        .environmentObject(ViewModel())
}
