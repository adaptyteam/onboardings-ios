//
//  ApplicationMainView.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 12.08.2024.
//

import Onboardings
import SwiftUI

struct ApplicationMainView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State var errorAlert: IdentifiableErrorWrapper?

    var body: some View {
        ZStack {
            NavigationView {
                ApplicationContentView()
            }
            .zIndex(0)

            if let onboardingId = viewModel.onboardingId {
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
                    onError: { error in
                        errorAlert = .init(value: error)
                    }
                )
                .transition(.opacity)
                .zIndex(1)
            } else if viewModel.onboardingIdLoading {
                ApplicationSplashView()
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
