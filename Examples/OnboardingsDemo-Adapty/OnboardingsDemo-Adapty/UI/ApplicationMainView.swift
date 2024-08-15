//
//  ApplicationMainView.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 12.08.2024.
//

import AdaptyUI
import Onboardings
import SwiftUI

struct ApplicationMainView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State var showOnboarding: Bool = true
    @State var showPaywall: Bool = false
    @State var errorAlert: IdentifiableErrorWrapper?

    @ViewBuilder
    private var applicationView: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        withAnimation {
                            showOnboarding = true
                            showPaywall = false
                            errorAlert = nil
                        }
                    } label: {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Welcome to Onboardings SDK!")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var body: some View {
        ZStack {
            if showPaywall, let paywall = viewModel.adaptyPaywall,
               let viewConfig = viewModel.adaptyViewConfiguration
            {
                applicationView
                    .zIndex(0)
                    .paywall(
                        isPresented: $showPaywall,
                        paywall: paywall,
                        viewConfiguration: viewConfig,
                        didFailPurchase: { _, _ in },
                        didFinishRestore: { _ in },
                        didFailRestore: { _ in },
                        didFailRendering: { _ in }
                    )
                    .onAppear {
                        showOnboarding = false
                    }
            } else {
                applicationView
                    .zIndex(0)
            }

            if showOnboarding, let onboardingId = viewModel.onboardingId {
                Onboardings.swiftuiView(
                    id: onboardingId,
                    splashViewBuilder: {
                        ApplicationSplashView()
                    },
                    onCloseAction: { _ in
                        withAnimation {
                            viewModel.setOnboardingFinished()
                        }
                    },
                    onOpenPaywallAction: { _ in
                        showPaywall = true
                    },
                    onStateUpdatedAction: { action in
                        viewModel.handleOnboardingStateUpdatedAction(action)
                    },
                    onAnalyticsEvent: { event in
                        viewModel.handleOnboardingAnalyticsEvent(event)
                    },
                    onError: { error in
                        errorAlert = .init(value: error)
                    }
                )
                .transition(.opacity)
                .zIndex(1)
            } else if viewModel.onboardingIdLoading {
                ApplicationSplashView()
                    .zIndex(1)
            }
        }
        .onAppear {
            viewModel.onError = { error in
                errorAlert = .init(value: error)
            }
            viewModel.loadOnboardingId()
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
