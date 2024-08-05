//
//  OctoflowsOnboardingView.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public class OctoflowsOnboardingView {
    public var delegate: OnboardingDelegate?
    public init(congiguration _: Configuration, delegate: OnboardingDelegate? = nil) {
        self.delegate = delegate
    }
}
