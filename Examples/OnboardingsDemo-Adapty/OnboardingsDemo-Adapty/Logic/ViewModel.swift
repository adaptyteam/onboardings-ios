//
//  ViewModel.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 12.08.2024.
//

import Adapty
import AdaptyUI
import Foundation
import Onboardings

enum AppConstants {
    enum Adapty {
        static let apiKey = "public_live_3MTW3h2c.eEnwTeoRyjgb9JbDcyEC"
        static let mainPlacementId = "paywall_onboarding_placement"
        static let onboardingPlacementId = "onboarding_placement"
        static let onboardingRemoteConfigKey = "octobuildy_id"
    }

    enum Onboardings {
        static let apiKey = "public_live_lzjhlp9e"
        static let onboardingId = "onboarding-fitness-app-small"
    }
}

class ViewModel: ObservableObject {
    @Published var onboardingIdLoading = true
    @Published var onboardingId: String?
    
    @Published var adaptyPaywall: AdaptyPaywall?
    @Published var adaptyViewConfiguration: AdaptyUI.LocalizedViewConfiguration?
    
    var onError: ((Error) -> Void)?

    @MainActor
    func initialize() {
        Adapty.logLevel = .verbose
        Adapty.activate(AppConstants.Adapty.apiKey)
        AdaptyUI.activate()

        loadOnboardingId()

        do {
            let configuration = OnboardingsConfiguration
                .builder(withAPIKey: AppConstants.Onboardings.apiKey)
                .with(loglevel: .verbose)

            try Onboardings.activate(with: configuration)
        } catch {
            onError?(error)
        }
    }

    func loadOnboardingId() {
        Task { @MainActor in
            do {
                let paywall = try await Adapty.getPaywall(placementId: AppConstants.Adapty.onboardingPlacementId)
                onboardingId = paywall.onboardingId
                onboardingIdLoading = false
            } catch {
                onError?(error)
            }
        }
    }

    func setOnboardingFinished() {
        onboardingId = nil
    }
    
    func loadOnboardingPaywall() {
        Task { @MainActor in
            do {
                let paywall = try await Adapty.getPaywall(placementId: AppConstants.Adapty.mainPlacementId)
                let viewConfig = try await AdaptyUI.getViewConfiguration(forPaywall: paywall)
                
                adaptyPaywall = paywall
                adaptyViewConfiguration = viewConfig
            } catch {
                onError?(error)
            }
        }
    }

    func handleOnboardingStateUpdatedAction(_ action: OnboardingsStateUpdatedAction) {
        guard let params = try? AdaptyProfileParameters.Builder()
            .with(stateUpdatedAction: action)
            .build() else { return }

        Adapty.updateProfile(params: params)
    }

    func handleOnboardingAnalyticsEvent(_ event: OnboardingsAnalyticsEvent) {
        switch event {
        case let .screenPresented(meta):
            Adapty.logShowOnboarding(
                name: meta.onboardingId,
                screenName: meta.screenClientId,
                screenOrder: UInt(meta.screenIndex)
            )
            
            if meta.screenClientId == "creating-your-plan" {
                loadOnboardingPaywall()
            }
        default:
            break
        }
    }
}

extension AdaptyPaywall {
    var onboardingId: String? {
        remoteConfig?.dictionary?[AppConstants.Adapty.onboardingRemoteConfigKey] as? String
    }
}

public extension AdaptyProfileParameters.Builder {
    @discardableResult
    func with(stateUpdatedAction action: OnboardingsStateUpdatedAction) throws -> Self {
        switch action.params {
        case let .select(params):
            try with(customAttribute: params.value, forKey: action.elementId)
        case let .multiSelect(params):
            try with(customAttribute: params.stringValue, forKey: action.elementId)
        case let .input(params):
            switch params {
            case let .text(stringValue):
                try with(customAttribute: stringValue, forKey: action.elementId)
            case let .email(stringValue):
                try with(customAttribute: stringValue, forKey: action.elementId)
            case let .number(doubleValue):
                try with(customAttribute: doubleValue, forKey: action.elementId)
            }
        case let .datePicker(params):
            try with(customAttribute: params.stringValue, forKey: action.elementId)
        }
    }
}

extension [OnboardingsSelectParams] {
    var stringValue: String {
        map { $0.value }.joined(separator: ",")
    }
}

extension OnboardingsDatePickerParams {
    var stringValue: String {
        "\(year)-\(String(format: "%.2d", month))-\(String(format: "%.2d", day))"
    }
}
