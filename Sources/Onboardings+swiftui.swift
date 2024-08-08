//
//  File.swift
//
//
//  Created by Aleksey Goncharov on 06.08.2024.
//

import SwiftUI

public typealias OnboardingActionParams = (clientId: String, meta: Onbordings.MetaParameters)
public typealias OnboardingStateUpdatedParams = (clientId: String, params: Onbordings.StateUpdatedParameters, meta: Onbordings.MetaParameters)

public struct OnboardingSplashView<Splash: View>: View {
    private let url: URL
    
    private let splashViewBuilder: () -> Splash
    private let onCloseAction: (OnboardingActionParams) -> Void
    private let onOpenPaywallAction: ((OnboardingActionParams) -> Void)?
    private let onCustomAction: ((OnboardingActionParams) -> Void)?
    private let onStateUpdated: ((OnboardingStateUpdatedParams) -> Void)?
    private let onAnalyticsEvent: ((Onbordings.AnalyticsEvent) -> Void)?
    private let onLoadingError: (Error) -> Void // TODO: change to SDK Error

    @State
    private var isLoading = true

    public init(
        url: URL,
        splashViewBuilder: @escaping () -> Splash,
        onCloseAction: @escaping (OnboardingActionParams) -> Void,
        onOpenPaywallAction: ((OnboardingActionParams) -> Void)?,
        onCustomAction: ((OnboardingActionParams) -> Void)?,
        onStateUpdated: ((OnboardingStateUpdatedParams) -> Void)?,
        onAnalyticsEvent: ((Onbordings.AnalyticsEvent) -> Void)?,
        onLoadingError: @escaping (Error) -> Void
    ) {
        self.url = url
        self.splashViewBuilder = splashViewBuilder
        self.onCloseAction = onCloseAction
        self.onOpenPaywallAction = onOpenPaywallAction
        self.onCustomAction = onCustomAction
        self.onStateUpdated = onStateUpdated
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
                onStateUpdated: onStateUpdated,
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

    public init(
        url: URL,
        onFinishLoading: @escaping () -> Void,
        onCloseAction: @escaping (OnboardingActionParams) -> Void,
        onOpenPaywallAction: ((OnboardingActionParams) -> Void)?,
        onCustomAction: ((OnboardingActionParams) -> Void)?,
        onStateUpdated: ((OnboardingStateUpdatedParams) -> Void)?,
        onAnalyticsEvent: ((Onbordings.AnalyticsEvent) -> Void)?,
        onLoadingError: @escaping (Error) -> Void
    ) {
        self.url = url
        self.onFinishLoading = onFinishLoading
        self.delegate = OnboardinViewDelegateImpl(
            onCloseAction: onCloseAction,
            onOpenPaywallAction: onOpenPaywallAction,
            onCustomAction: onCustomAction,
            onStateUpdated: onStateUpdated,
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

final class OnboardinViewDelegateImpl: NSObject, OnboardingDelegate {
    private let onCloseAction: (OnboardingActionParams) -> Void
    private let onOpenPaywallAction: ((OnboardingActionParams) -> Void)?
    private let onCustomAction: ((OnboardingActionParams) -> Void)?
    private let onStateUpdated: ((OnboardingStateUpdatedParams) -> Void)?
    private let onAnalyticsEvent: ((Onbordings.AnalyticsEvent) -> Void)?
    private let onLoadingError: (Error) -> Void // TODO: change to SDK Error

    init(
        onCloseAction: @escaping (OnboardingActionParams) -> Void,
        onOpenPaywallAction: ((OnboardingActionParams) -> Void)?,
        onCustomAction: ((OnboardingActionParams) -> Void)?,
        onStateUpdated: ((OnboardingStateUpdatedParams) -> Void)?,
        onAnalyticsEvent: ((Onbordings.AnalyticsEvent) -> Void)?,
        onLoadingError: @escaping (Error) -> Void
    ) {
        self.onCloseAction = onCloseAction
        self.onOpenPaywallAction = onOpenPaywallAction
        self.onCustomAction = onCustomAction
        self.onStateUpdated = onStateUpdated
        self.onAnalyticsEvent = onAnalyticsEvent
        self.onLoadingError = onLoadingError
    }

    func onboardingsCloseAction(clientId: String, withMeta: Onbordings.MetaParameters) {
        onCloseAction((clientId: clientId, meta: withMeta))
    }

    func openPaywallAction(clientId: String, withMeta: Onbordings.MetaParameters) {
        if let onOpenPaywallAction {
            onOpenPaywallAction((clientId: clientId, meta: withMeta))
        } else {
            Log.warn("OnboardingView: Not implimented callback 'onOpenPaywallAction'")
        }
    }

    func customAction(clientId: String, withMeta: Onbordings.MetaParameters) {
        if let onCustomAction {
            onCustomAction((clientId: clientId, meta: withMeta))
        } else {
            Log.warn("OnboardingView: Not implimented callback 'onCustomAction'")
        }
    }

    func stateUpdated(clientId: String, params: Onbordings.StateUpdatedParameters, withMeta: Onbordings.MetaParameters) {
        if let onStateUpdated {
            onStateUpdated((clientId: clientId, params: params, meta: withMeta))
        } else {
            Log.warn("OnboardingView: Not implimented callback 'onStateUpdated'")
        }
    }

    func onAnalyticsEvent(event: Onbordings.AnalyticsEvent) {
        if let onAnalyticsEvent {
            onAnalyticsEvent(event)
        } else {
            Log.warn("OnboardingView: Not implimented callback 'onAnalyticsEvent'")
        }
    }

    func onLoadingError(_ error: Error) {
        onLoadingError(error)
    }
}
