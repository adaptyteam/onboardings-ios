//
//  File.swift
//
//
//  Created by Aleksey Goncharov on 06.08.2024.
//

import SwiftUI

@available(iOS 14.0, *)
public struct OnboardingSplashView<Splash: View>: View {
    private let splashViewBuilder: () -> Splash

    @State
    private var isLoading = true

    public init(splashViewBuilder: @escaping () -> Splash) {
        self.splashViewBuilder = splashViewBuilder
    }

    public var body: some View {
        ZStack {
            OnboardingView(
                url: URL(string: "https://x.fnlfx.com/funnel_a")!,
                onFinishLoading: { _ in
                    isLoading = false
                }
            )

            if isLoading {
                splashViewBuilder()
            }
        }
        .ignoresSafeArea()
    }
}

public struct OnboardingView: UIViewControllerRepresentable {
    private let delegate = OnboardinViewDelegateImpl()

    let url: URL
    let onFinishLoading: (Error?) -> Void

    public init(
        url: URL,
        onFinishLoading: @escaping (Error?) -> Void
    ) {
        self.url = url
        self.onFinishLoading = onFinishLoading
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        OnboardingController(url: url,
                             delegate: delegate,
                             onFinishLoading: onFinishLoading)
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

final class OnboardinViewDelegateImpl: NSObject, OnboardingDelegate {
    func onboardingsCloseAction() {}
}
