//
//  OnboardingController.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import UIKit
import WebKit

public class OnboardingController: UIViewController {
    let viewModel: OnboardingViewModel
    var delegate: OnboardingDelegate

    private var webView: WKWebView!

    public init(url: URL, delegate: OnboardingDelegate) {
        self.delegate = delegate
        self.viewModel = OnboardingViewModel(url: url)

        super.init(nibName: nil, bundle: nil)
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
        viewModel.onFinishLoading = { [weak self] in
        }
        viewModel.onClose = { [weak self] in
            self?.delegate.octoflowsCloseAction()
        }
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
