//
//  OctoflowsOnboardingView.swift
//
//
//  Created by Aleksei Valiano on 01.08.2024
//
//

import Foundation

public class OctoflowsOnboardingView {
    public var delegate: OctoflowsOnboardingViewDelegate?
    public init(congiguration _: Configuration, delegate: OctoflowsOnboardingViewDelegate? = nil) {
        self.delegate = delegate
    }
}
