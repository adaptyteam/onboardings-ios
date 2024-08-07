//
//  AnalyticsEvent.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings {
    
    public enum AnalyticsEventName: String, Sendable {
        case onboardingStarted = "onboarding_started"
        case screenPresented = "screen_presented"
        case screenCompleted = "screen_completed"
        case secondScreenPresented = "second_screen_presented"
        case registrationScreenPresented = "registration_screen_presented"
        case productsScreenPresented = "products_screen_presented"
        case userEmailCollected = "user_email_collected"
        case onboardingCompleted = "onboarding_completed"
    }

    public struct AnalyticsEvent: Sendable, Hashable {
        public let name: AnalyticsEventName
        public let meta: MetaParameters

        init(_ body: BodyDecoder.Dictionary) throws {
            self.meta = try MetaParameters(body["meta"])
            guard let name = try AnalyticsEventName(rawValue: body["name"].asString()) else {
                throw BodyDecoderError.wrongValue
            }
            self.name = name
        }
    }
}
