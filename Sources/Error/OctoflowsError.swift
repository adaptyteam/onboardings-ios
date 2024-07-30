//
//  OctoflowsError.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

public enum OctoflowsError: Error, Sendable {
    case notActivated(Source)
    case activateOnce(Source)
}

extension OctoflowsError {
    public var source: Source {
        switch self {
        case let .activateOnce(src),
             let .notActivated(src):
            src
        }
    }

    public var underlyingError: Error? {
        switch self {
        default:
            nil
        }
    }
}
