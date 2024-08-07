//
//  OnbordingsError.Code.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public extension OctoflowsError {
    enum Code: Int {
        case unknown = 0
        case wrongApiKey = 1
        case notActivated = 2
        case activateOnce = 3
    }

    var code: Code {
        switch self {
        case .wrongApiKey: .wrongApiKey
        case .notActivated: .notActivated
        case .activateOnce: .activateOnce
        }
    }
}
