//
//  Log+currentThreadName.swift
//
//
//  Created by Aleksei Valiano on 06.08.2024
//
//

import Foundation

extension Log {
    @inlinable
    package nonisolated static var currentThreadName: String {
        String(cString: __dispatch_queue_get_label(nil), encoding: .utf8)
            ?? Thread.current.description
    }
}
