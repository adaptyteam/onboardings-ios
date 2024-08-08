//
//  OnboardingViewModel.swift
//  Onboardings
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import Foundation
import WebKit

final class OnboardingViewModel: NSObject, ObservableObject {
    let stamp: String
    let url: URL

    // TODO: change `var` to `let` , and dont use "!". this params can be @Sendable and setup in init
    var onMessage: ((Onboardings.Message) -> Void)!
    // TODO: change `var` to `let` , and dont use "!". this params can be @Sendable and setup in init
    var onError: ((Error) -> Void)!

    init(stamp: String, url: URL) {
        self.stamp = stamp
        self.url = url
    }

    @MainActor
    func configureWebView(_ webView: WKWebView) {
        let stamp = self.stamp
        Log.verbose("#OnboardingViewModel_\(stamp)# configureWebView")

        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: "postEvent")

        let userScript = WKUserScript(
            source: Onboardings.jsCodeInjection,
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
        let stamp = self.stamp
        Log.verbose("#OnboardingViewModel_\(stamp)# webView didStartProvisionalNavigation")
    }

    public func webView(_: WKWebView, didFinish _: WKNavigation!) {
        let stamp = self.stamp
        Log.verbose("#OnboardingViewModel_\(stamp)# webView didFinish navigation")
    }

    public func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        let stamp = self.stamp
        Log.error("#OnboardingViewModel_\(stamp)# didFail navigation withError \(error)")
        onError(error)
    }

    public func userContentController(_: WKUserContentController, didReceive wkMessage: WKScriptMessage) {
        let stamp = self.stamp
        do {
            let message = try Onboardings.Message(chanel: wkMessage.name, body: wkMessage.body)
            Log.verbose("#OnboardingViewModel_\(stamp)# On message: \(message)")
            onMessage(message)
        } catch let error as Onboardings.UnknownMessageError {
            let wkMessageBody = String(describing: wkMessage.body)
            Log.warn("#OnboardingViewModel_\(stamp)# Unknown message \(error.type.map { "with type \"\($0)\"" } ?? "with name \"\(error.chanel)\""): \(wkMessageBody)")
        } catch {
            Log.error("#OnboardingViewModel_\(stamp)# Error on decoding event: \(error)")
        }
    }
}

private extension Onboardings {
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
