//
//  PrivateEvent+Example.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Onbordings.PrivateEvent {
    struct ExampleParameters: Sendable, Hashable {
        let date: Date

        init(_ body: Any) throws {
            self.date = Date()

            guard let _ = try BodyDecoder.decode(body).asOptionalDictionary() else { return }
        }
    }
}
