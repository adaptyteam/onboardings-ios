//
//  ContentView.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var customBaseUrl: String = Storage.customBaseUrl ?? "https://1a.fnlfx.dev/"
    
    @State var onboardingId: String = Storage.onboardingId ?? "7-aug"
    
    var body: some View {
        List {
            Section {
                TextField("Enter URL", text: $customBaseUrl)
            } header: {
                Text("Override Base URL")
            } footer: {
                Text("Reload the application to apply changes")
            }
                
            Section {
                TextField("Enter Onboarding Id", text: $onboardingId)
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
                    Storage.onboardingId = onboardingId.isEmpty ? nil : onboardingId
                    Storage.customBaseUrl = customBaseUrl.isEmpty ? nil : customBaseUrl
                } label: {
                    Text("Save")
                        .bold()
                }
                .disabled(
                    onboardingId == Storage.onboardingId ?? "" &&
                        customBaseUrl == Storage.customBaseUrl ?? ""
                )
            }
        }
        .navigationTitle("Welcome to Onboardings SDK!")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
