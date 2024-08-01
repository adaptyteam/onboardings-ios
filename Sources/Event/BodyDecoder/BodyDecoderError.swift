//
//  BodyDecoderError.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

enum BodyDecoderError: Error {
    case valueIsNil
    case valueIsNotDictionary
    case valueIsNotArray
    case valueIsNotNSNumber
    case valueIsNotString
    case valueIsNotDate
}
