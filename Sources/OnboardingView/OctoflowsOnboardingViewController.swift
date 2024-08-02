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

    public init(url: URL) {
        self.url = url

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

//        Octoflows.onActivate = {
//            // code
//        }
//        let task = Task {
//            return 5
//        }
//
//        let value = await task.value

        let webView = self.buildWebView()
        self.layoutWebView(webView)
        self.webView = webView
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
    }

    public func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        print("Failed to load with error: \(error.localizedDescription)")
//        isLoading = false
    }

    public func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "closeWebView", let messageBody = message.body as? String, messageBody == "close" {
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
