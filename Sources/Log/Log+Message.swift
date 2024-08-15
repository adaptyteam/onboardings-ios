//
//  Log+Message.swift
//
//
//  Created by Aleksei Valiano on 06.08.2024
//
//

import Foundation

extension Log {
    package struct Message: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
        package typealias StringLiteralType = String

        package let value: String

        package init(stringLiteral value: String) {
            self.value = value
        }
    }
}
