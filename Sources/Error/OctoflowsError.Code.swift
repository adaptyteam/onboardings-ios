//
//  OctoflowsError.Code.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public extension OctoflowsError {
    enum Code: Int {
        case unknown = 0
        case notActivated = 1
        case activateOnce = 2
    }

    var code: Code {
        switch self {
        case .notActivated: .notActivated
        case .activateOnce: .activateOnce
        }
    }
}
