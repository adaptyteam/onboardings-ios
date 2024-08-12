//
//  Storage.swift
//  OnboardingsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 12.08.2024.
//

import Foundation

enum Storage {
    private static var _customBaseUrl: String?
    private static var _customOnboardingId: String?
    
    static var customBaseUrl: String? {
        if let _customBaseUrl {
            return _customBaseUrl
        }
        
        let value = UserDefaults.standard.string(forKey: "app.baseurl")
        _customBaseUrl = value
        return _customBaseUrl
    }
    
    static func setCustomBaseUrl(_ value: String?) {
        _customBaseUrl = value
        
        if let value {
            UserDefaults.standard.setValue(value, forKey: "app.baseurl")
        } else {
            UserDefaults.standard.removeObject(forKey: "app.baseurl")
        }
    }
    
    static var onboardingId: String? {
        if let _customOnboardingId {
            return _customOnboardingId
        }
        
        let value = UserDefaults.standard.string(forKey: "app.onboarding.id")
        _customOnboardingId = value
        return _customOnboardingId
    }
    
    static func setOnboardingId(_ value: String?) {
        _customOnboardingId = value
        
        if let value {
            UserDefaults.standard.setValue(value, forKey: "app.onboarding.id")
        } else {
            UserDefaults.standard.removeObject(forKey: "app.onboarding.id")
        }
    }
}
