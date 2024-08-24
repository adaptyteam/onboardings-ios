//
//  OnboardingsLog.Handler.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation

extension OnboardingsLog {
    public typealias Handler = @Sendable (OnboardingsLog.Record) -> Void
}
