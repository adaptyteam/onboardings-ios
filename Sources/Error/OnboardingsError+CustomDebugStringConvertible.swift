//
//  OnboardingsError+CustomDebugStringConvertible.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension OnboardingsError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .wrongApiKey(_, description):
            "Wrong ApiKey, " + description
        case .notActivated: "The Onboardings is not activated."
        case .activateOnce: "It is not possible to call `.activate` method more than once."
        case let .webKit(_, error): "WebKit produced an error: \(error.localizedDescription)"
        }
    }
}
