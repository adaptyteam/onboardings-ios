//
//  AnalyticsEvent.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings {
    public enum AnalyticsEvent: Sendable, Hashable {
        case unknown(meta: MetaParameters)
        case onboardingStarted(meta: MetaParameters)
        case screenPresented(meta: MetaParameters)
        case screenCompleted(meta: MetaParameters, formClientId: String?, reply: String?)
        case secondScreenPresented(meta: MetaParameters)
        case registrationScreenPresented(meta: MetaParameters)
        case productsScreenPresented(meta: MetaParameters)
        case userEmailCollected(meta: MetaParameters)
        case onboardingCompleted(meta: MetaParameters)

        public var meta: MetaParameters {
            switch self {
            case let .unknown(meta),
                 let .onboardingStarted(meta),
                 let .screenPresented(meta),
                 let .screenCompleted(meta, _, _),
                 let .secondScreenPresented(meta),
                 let .registrationScreenPresented(meta),
                 let .productsScreenPresented(meta),
                 let .userEmailCollected(meta),
                 let .onboardingCompleted(meta):
                meta
            }
        }

        init(_ body: BodyDecoder.Dictionary) throws {
            let meta = try MetaParameters(body["meta"])

            enum Name: String, Sendable {
                case onboardingStarted = "onboarding_started"
                case screenPresented = "screen_presented"
                case screenCompleted = "screen_completed"
                case secondScreenPresented = "second_screen_presented"
                case registrationScreenPresented = "registration_screen_presented"
                case productsScreenPresented = "products_screen_presented"
                case userEmailCollected = "user_email_collected"
                case onboardingCompleted = "onboarding_completed"
            }

            let name = try body["name"].asString()
            let params = try body["params"].asOptionalDictionary()

            self = switch Name(rawValue: name) {
            case .none:
                .unknown(meta: meta)
            case .onboardingStarted:
                .onboardingStarted(meta: meta)
            case .screenPresented:
                .screenPresented(meta: meta)
            case .screenCompleted:
                try .screenCompleted(
                    meta: meta,
                    formClientId: params?["form_cid"].asOptionalString(),
                    reply: params?["reply"].asOptionalString()
                )
            case .secondScreenPresented:
                .secondScreenPresented(meta: meta)
            case .registrationScreenPresented:
                .registrationScreenPresented(meta: meta)
            case .productsScreenPresented:
                .productsScreenPresented(meta: meta)
            case .userEmailCollected:
                .userEmailCollected(meta: meta)
            case .onboardingCompleted:
                .onboardingCompleted(meta: meta)
            }
        }
    }
}
