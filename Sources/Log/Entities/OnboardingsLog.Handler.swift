//
//  OnboardingsLog.Handler.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension Log {
    package typealias Handler = OnboardingsLog.Handler
}

extension OnboardingsLog {
    public typealias Handler = @Sendable (Record) -> Void
}
