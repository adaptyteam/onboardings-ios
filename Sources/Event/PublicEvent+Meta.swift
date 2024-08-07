//
//  PublicEvent+Menta.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings.PublicEvent {
    public struct MetaParameters: Sendable, Hashable {
        let onboardingId: String
        let screenClientId: String
        let screenIndex: Int

        init(_ body: BodyDecoder.Value) throws {
            let body = try body.asDictionary()
            self.onboardingId = try body["onboarding_id"].asString()
            self.screenClientId = try body["screen_cid"].asString()
            self.screenIndex = try body["screen_index"].asInt()
        }
    }
}
