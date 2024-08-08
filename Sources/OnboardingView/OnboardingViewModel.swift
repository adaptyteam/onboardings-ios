//
//  OnboardingViewModel.swift
//  Onbordings
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import Foundation
import WebKit

class OnboardingViewModel: NSObject, ObservableObject {
    let stamp: String
    let url: URL
    
    var onEvent: ((Onbordings.Event) -> Void)!
    var onError: ((Error) -> Void)!

    init( stamp: String,  url: URL   ) {
        self.stamp = stamp
        self.url = url
    }

    func configureWebView(_ webView: WKWebView) {
        Log.verbose("#OnboardingViewModel_\(self.stamp)# configureWebView")

        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: "postEvent")

        let userScript = WKUserScript(
            source: Onbordings.jsCodeInjection,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )

        webView.configuration.userContentController.addUserScript(userScript)

        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension OnboardingViewModel: WKNavigationDelegate, WKScriptMessageHandler {
    public func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        Log.verbose("#OnboardingViewModel_\(self.stamp)# webView didStartProvisionalNavigation")
    }

    public func webView(_: WKWebView, didFinish _: WKNavigation!) {
        Log.verbose("#OnboardingViewModel_\(self.stamp)# webView didFinish navigation")
    }

    public func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        Log.error("#OnboardingViewModel_\(self.stamp)# didFail navigation withError \(error)")
        onError(error)
    }

    public func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        do {
            let event = try Onbordings.Event(chanel: message.name, body: message.body)
            
            Log.verbose("#OnboardingViewModel_\(self.stamp)# On event: \(event)")
            onEvent(event)
        } catch let error as Onbordings.UnknownEventError {
            let message = String(describing: message.body)
            Log.warn("#OnboardingViewModel_\(self.stamp)# Unknown event \(error.type.map { "with type \"\($0)\"" } ?? "with name \"\(error.chanel)\""): \(message)")
        } catch {
            Log.error("#OnboardingViewModel_\(self.stamp)# Error on decoding event: \(error)")
        }
    }
}

private extension Onbordings {
    static let jsCodeInjection = """
    function waitForElm(selector, callback) {
        var selectedElement = document.querySelector(selector);
        if (selectedElement) {
            return callback(selectedElement);
        }

        var observer = new MutationObserver(function (mutations) {
            var selectedElement = window.fox

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
        fox.inputs.subscribeAll((k, v) => {
            window.webkit.messageHandlers.postEvent.postMessage(v)
        })
    })
    """
}
