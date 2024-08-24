//
//   OnboardingsLog.Category.swift
//
//
//  Created by Aleksei Valiano on 23.08.2024
//
//

import Foundation

extension Log {
    package typealias Category = OnboardingsLog.Category
}

public enum OnboardingsLog {
    public struct Category: Sendable, Hashable {
        public let subsystem: String
        public let version: String
        public let name: String

        package init(subsystem: String? = nil, version: String? = nil, name: String) {
            self.subsystem = subsystem ?? Log.default.subsystem
            self.version = version ?? Log.default.version
            self.name = name
        }
    }
}

extension OnboardingsLog.Category: CustomStringConvertible {
    public var description: String {
        if name == Log.default.name {
            "[\(subsystem) v\(version)]"
        } else {
            "[\(subsystem) v\(version)] #\(name)#"
        }
    }
}
