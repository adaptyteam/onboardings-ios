//
//  OnboardingViewModel.swift
//  Onbordings
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import Foundation
import WebKit

class OnboardingViewModel: NSObject, ObservableObject {
    let url: URL

    var onFinishLoading: ((Error?) -> Void)?
    var onClose: (() -> Void)?

    init(url: URL) {
        self.url = url
    }

    func configureWebView(_ webView: WKWebView) {
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: "closeWebView")
        webView.configuration.userContentController.add(self, name: "sendData")

        // Inject JavaScript
        let userScript = WKUserScript(
            source: Onbordings.jsCodeInjection,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )

        webView.configuration.userContentController.addUserScript(userScript)

        // Load the URL request
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension OnboardingViewModel: WKNavigationDelegate, WKScriptMessageHandler {
    public func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {}

    public func webView(_: WKWebView, didFinish _: WKNavigation!) {
        onFinishLoading?(nil)
    }

    public func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        onFinishLoading?(error)
    }

    public func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "closeWebView",
           let messageBody = message.body as? String, messageBody == "close"
        {
            onClose?()
        }
    }
}

private extension Onbordings {
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
