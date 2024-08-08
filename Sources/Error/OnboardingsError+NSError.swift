//
//  OnboardingsError+NSError.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension OnboardingsError: CustomNSError {
    public static let errorDomain = "OnboardingsErrorDomain"

    public var errorCode: Int { code.rawValue }

    public var errorUserInfo: [String: Any] {
        var data: [String: Any] = [
            NSDebugDescriptionErrorKey: debugDescription,
            UserInfoKeys.source.rawValue: source.description,
        ]

        if let underlyingError {
            data[NSUnderlyingErrorKey] = underlyingError as NSError
        }

        return data
    }

    public enum UserInfoKeys: String {
        case source = "Source"
    }
}
