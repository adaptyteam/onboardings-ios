//
//  File.swift
//
//
//  Created by Aleksey Goncharov on 06.08.2024.
//

import SwiftUI

public struct OnboardingSplashView<Splash: View>: View {
    private let url: URL

    private let splashViewBuilder: () -> Splash
    private let onCloseAction: (OnboardingsCloseAction) -> Void
    private let onOpenPaywallAction: ((OnboardingsOpenPaywallAction) -> Void)?
    private let onCustomAction: ((OnboardingsCustomAction) -> Void)?
    private let onStateUpdatedAction: ((OnboardingsStateUpdatedAction) -> Void)?
    private let onAnalyticsEvent: ((OnboardingsAnalyticsEvent) -> Void)?
    private let onLoadingError: (Error) -> Void // TODO: change to SDK Error

    @State
    private var isLoading = true

    public init( // TODO: init must be internal , the URL of the onboarding's data must not be publicly available for setup
        url: URL,
        splashViewBuilder: @escaping () -> Splash,
        onCloseAction: @escaping (OnboardingsCloseAction) -> Void,
        onOpenPaywallAction: ((OnboardingsOpenPaywallAction) -> Void)?,
        onCustomAction: ((OnboardingsCustomAction) -> Void)?,
        onStateUpdatedAction: ((OnboardingsStateUpdatedAction) -> Void)?,
        onAnalyticsEvent: ((OnboardingsAnalyticsEvent) -> Void)?,
        onLoadingError: @escaping (Error) -> Void
    ) {
        self.url = url
        self.splashViewBuilder = splashViewBuilder
        self.onCloseAction = onCloseAction
        self.onOpenPaywallAction = onOpenPaywallAction
        self.onCustomAction = onCustomAction
        self.onStateUpdatedAction = onStateUpdatedAction
        self.onAnalyticsEvent = onAnalyticsEvent
        self.onLoadingError = onLoadingError
    }

    @ViewBuilder
    private var zstackBody: some View {
        ZStack {
            OnboardingView(
                url: url,
                onFinishLoading: {
                    isLoading = false
                },
                onCloseAction: onCloseAction,
                onOpenPaywallAction: onOpenPaywallAction,
                onCustomAction: onCustomAction,
                onStateUpdatedAction: onStateUpdatedAction,
                onAnalyticsEvent: onAnalyticsEvent,
                onLoadingError: onLoadingError
            )

            if isLoading {
                splashViewBuilder()
            }
        }
    }

    public var body: some View {
        if #available(iOS 14.0, *) {
            zstackBody
                .ignoresSafeArea()
        } else {
            zstackBody
                .edgesIgnoringSafeArea(.all)
        }
    }
}

public struct OnboardingView: UIViewControllerRepresentable {
    private let delegate: OnboardingDelegate
    private let url: URL
    private let onFinishLoading: () -> Void

    public init( // TODO: init must be internal , the URL of the onboarding's data must not be publicly available for setup
        url: URL,
        onFinishLoading: @escaping () -> Void,
        onCloseAction: @escaping (OnboardingsCloseAction) -> Void,
        onOpenPaywallAction: ((OnboardingsOpenPaywallAction) -> Void)?,
        onCustomAction: ((OnboardingsCustomAction) -> Void)?,
        onStateUpdatedAction: ((OnboardingsStateUpdatedAction) -> Void)?,
        onAnalyticsEvent: ((OnboardingsAnalyticsEvent) -> Void)?,
        onLoadingError: @escaping (Error) -> Void
    ) {
        self.url = url
        self.onFinishLoading = onFinishLoading
        self.delegate = OnboardingDelegateImpl(
            onCloseAction: onCloseAction,
            onOpenPaywallAction: onOpenPaywallAction,
            onCustomAction: onCustomAction,
            onStateUpdatedAction: onStateUpdatedAction,
            onAnalyticsEvent: onAnalyticsEvent,
            onLoadingError: onLoadingError
        )
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        OnboardingController(
            url: url,
            delegate: delegate,
            onFinishLoading: onFinishLoading
        )
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

final class OnboardingDelegateImpl: NSObject, OnboardingDelegate {
    private let onCloseAction: (OnboardingsCloseAction) -> Void
    private let onOpenPaywallAction: ((OnboardingsOpenPaywallAction) -> Void)?
    private let onCustomAction: ((OnboardingsCustomAction) -> Void)?
    private let onStateUpdatedAction: ((OnboardingsStateUpdatedAction) -> Void)?
    private let onAnalyticsEvent: ((OnboardingsAnalyticsEvent) -> Void)?
    private let onLoadingError: (Error) -> Void // TODO: change to SDK Error

    init(
        onCloseAction: @escaping (OnboardingsCloseAction) -> Void,
        onOpenPaywallAction: ((OnboardingsOpenPaywallAction) -> Void)?,
        onCustomAction: ((OnboardingsCustomAction) -> Void)?,
        onStateUpdatedAction: ((OnboardingsStateUpdatedAction) -> Void)?,
        onAnalyticsEvent: ((OnboardingsAnalyticsEvent) -> Void)?,
        onLoadingError: @escaping (Error) -> Void
    ) {
        self.onCloseAction = onCloseAction
        self.onOpenPaywallAction = onOpenPaywallAction
        self.onCustomAction = onCustomAction
        self.onStateUpdatedAction = onStateUpdatedAction
        self.onAnalyticsEvent = onAnalyticsEvent
        self.onLoadingError = onLoadingError
    }

    func onboardingsCloseAction(_ action: OnboardingsCloseAction) {
        onCloseAction(action)
    }

    func openPaywallAction(_ action: OnboardingsOpenPaywallAction) {
        if let onOpenPaywallAction {
            onOpenPaywallAction(action)
        } else {
            Log.warn("OnboardingView: Not implimented callback 'onOpenPaywallAction'")
        }
    }

    func customAction(_ action: OnboardingsCustomAction) {
        if let onCustomAction {
            onCustomAction(action)
        } else {
            Log.warn("OnboardingView: Not implimented callback 'onCustomAction'")
        }
    }

    func stateUpdatedAction(_ action: OnboardingsStateUpdatedAction) {
        if let onStateUpdatedAction {
            onStateUpdatedAction(action)
        } else {
            Log.warn("OnboardingView: Not implimented callback 'onStateUpdated'")
        }
    }

    func onAnalyticsEvent(_ event: OnboardingsAnalyticsEvent) {
        onAnalyticsEvent?(event)
    }

    func onLoadingError(_ error: Error) {
        onLoadingError(error)
    }
}
