//
//  OnboardingController.swift
//
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import UIKit
import WebKit

public class OnboardingController: UIViewController {
    let stamp: String
    let viewModel: OnboardingViewModel
    var delegate: OnboardingDelegate

    private let onFinishLoading: () -> Void

    private var webView: WKWebView!

    public init(
        url: URL,
        delegate: OnboardingDelegate,
        onFinishLoading: @escaping () -> Void
    ) {
        let stamp = Log.stamp

        self.stamp = stamp
        self.delegate = delegate
        self.viewModel = OnboardingViewModel(stamp: stamp, url: url)
        self.onFinishLoading = onFinishLoading

        super.init(nibName: nil, bundle: nil)

        viewModel.onError = { [weak delegate] error in
            delegate?.apply(error: error)
        }
        
        viewModel.onEvent = { [weak delegate] event in
            if case .analytics(let event) = event, case .onboardingStarted(let meta) = event {
                onFinishLoading()
            }

            delegate?.apply(event: event)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let webView = buildWebView()
        layoutWebView(webView)
        self.webView = webView

        viewModel.configureWebView(webView)
    }

    private func buildWebView() -> WKWebView {
        let webView = WKWebView()

        return webView
    }

    private func layoutWebView(_ webView: WKWebView) {
        webView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(webView)
        view.addConstraints([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
