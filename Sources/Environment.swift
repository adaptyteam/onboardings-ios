//
//  Environment.swift
//
//
//  Created by Aleksei Valiano on 30.07.2024
//
//

import Foundation
#if canImport(UIKit)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

enum Environment {
    enum Application {
        static let name: String? = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        static let version: String? = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
    }
}
