//
//  Log+sdk.swift
//
//
//  Created by Aleksei Valiano on 24.08.2024
//
//

import Foundation

extension Log {
    package static let `default` = OnboardingsLog.Category(
        subsystem: "io.adapty.onboardings",
        version: Onboardings.SDKVersion,
        name: "sdk"
    )
}
