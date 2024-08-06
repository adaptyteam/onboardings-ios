//
//  File.swift
//
//
//  Created by Aleksey Goncharov on 06.08.2024.
//

import SwiftUI

struct OnboardingView: UIViewControllerRepresentable {
    private let delegate = OnboardinViewDelegateImpl()
    
    let url: URL
    let onFinishLoading: (Error?) -> Void
    
    init(
        url: URL,
        onFinishLoading: @escaping (Error?) -> Void
    ) {
        self.url = url
        self.onFinishLoading = onFinishLoading
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        OnboardingController(url: url,
                             delegate: delegate,
                             onFinishLoading: onFinishLoading)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

final class OnboardinViewDelegateImpl: NSObject, OnboardingDelegate {
    func octoflowsCloseAction() {}
}
