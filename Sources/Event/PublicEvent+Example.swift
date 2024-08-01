//
//  PublicEvent+Example.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

extension Octoflows.PublicEvent {
    public struct ExampleParameters: Sendable, Hashable {
        let str: String
        let number: Int?

        init(_ body: Any) throws {
            let body = try BodyDecoder.decode(body).asDictionary()
            self.str = try body["str"].asString()
            self.number = try body["number"].asOptionalInt()
        }
    }
}
