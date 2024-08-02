//
//  OctoflowsOnboardingViewController.swift
//  OctoflowsDemo-UIKit
//
//  Created by Aleksey Goncharov on 02.08.2024.
//

import UIKit
import WebKit

public final class OctoflowsOnboardingViewController: UIViewController {
    private var webView: WKWebView!

    private let url: URL
    private var delegate: OctoflowsOnboardingViewDelegate
    private weak var applicationSplashVC: UIViewController?

    public init(url: URL, delegate: OctoflowsOnboardingViewDelegate) {
        self.url = url
        self.delegate = delegate

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

        applicationSplashVC = layoutApplicationSplash()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        applicationSplashVC?.beginAppearanceTransition(true, animated: animated)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        applicationSplashVC?.endAppearanceTransition()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        applicationSplashVC?.beginAppearanceTransition(false, animated: animated)
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        applicationSplashVC?.endAppearanceTransition()
    }

    private func layoutApplicationSplash() -> UIViewController? {
        guard let childVC = delegate.octoflowsSplashViewController() else {
            return nil
        }

        view.addSubview(childVC.view)
        addChild(childVC)
        childVC.didMove(toParent: self)

        view.addConstraints([
            childVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        childVC.view.clipsToBounds = true

        return childVC
    }

    private func removeApplicationSplash() {
        guard let applicationSplashVC else { return }

        UIView.animate(
            withDuration: 0.3,
            delay: 0.5,
            animations: {
                applicationSplashVC.view.alpha = 0.0

            }, completion: { _ in
                applicationSplashVC.willMove(toParent: nil)
                applicationSplashVC.view.removeFromSuperview()
                applicationSplashVC.removeFromParent()

                self.applicationSplashVC = nil
            }
        )
    }

    private func buildWebView() -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: "closeWebView")
        webView.configuration.userContentController.add(self, name: "sendData")

        // Inject JavaScript
        let userScript = WKUserScript(
            source: Octoflows.jsCodeInjection,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )

        webView.configuration.userContentController.addUserScript(userScript)

        // Load the URL request
        let request = URLRequest(url: url)
        webView.load(request)

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

extension OctoflowsOnboardingViewController: WKNavigationDelegate, WKScriptMessageHandler {
    public func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        print("Started loading")
//        isLoading = true
    }

    public func webView(_: WKWebView, didFinish _: WKNavigation!) {
        print("Finished loading")
//        isLoading = false

        removeApplicationSplash()
    }

    public func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        print("Failed to load with error: \(error.localizedDescription)")
//        isLoading = false
    }

    public func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "closeWebView", let messageBody = message.body as? String, messageBody == "close" {
            delegate.octoflowsCloseAction()
//            print("Close message received")
//            withAnimation {
//                self.parent.isPresented = false
//            }
//        } else if message.name == "sendData", let messageBody = message.body as? String {
//            print("Data received: \(messageBody)")
//            self.parent.receivedMessage = messageBody
//
//            if message.body as? String == "show paywall" {
//                self.parent.paywallPresented = true
//            }
        }
    }
}

private extension Octoflows {
    static let jsCodeInjection = """
    // Create a new meta element
    var metaTag = document.createElement('meta');

    // Set the name attribute
    metaTag.setAttribute('name', 'viewport');

    // Set the content attribute
    metaTag.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no');

    // Append the meta tag to the head of the document
    document.getElementsByTagName('head')[0].appendChild(metaTag);


    document.addEventListener('click', function (event) {
      if (event && event.target) {
        window.webkit.messageHandlers.sendData.postMessage(event.target.tagName);
      }
    });


    function showPaywall() {
      sendDataToApp('show paywall')
    }

    function closeWebView() {
      window.webkit.messageHandlers.closeWebView.postMessage('close');
    }

    function sendDataToApp(data) {
      window.webkit.messageHandlers.sendData.postMessage(data);
    }

    function waitForElm(selector, callback) {
      var selectedElement = document.querySelector(selector);
      if (selectedElement) {

        return callback(selectedElement);
      }

      var observer = new MutationObserver(function (mutations) {
        var selectedElement = document.querySelector(selector);
        sendDataToApp('observer')
        if (selectedElement) {
          observer.disconnect();
          callback(selectedElement);
        }
      });

      // Observes the document body for changes in the DOM
      observer.observe(document.body, {
        childList: true,
        subtree: true
      });
    }

    waitForElm('main', function (element) {
      sendDataToApp('element main found')
      fox.inputs.subscribeAll((k, v) => {
        window.webkit.messageHandlers.sendData.postMessage(JSON.stringify(v))

        if (v && v.label.toLowerCase() === 'open paywall') {
          showPaywall()
        }

        if (v && v.label.toLowerCase()  === 'close onboarding') {
          closeWebView()
        }

      })
    })

    """
}
