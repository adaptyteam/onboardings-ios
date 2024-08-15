//
//  OnboardingViewModel.swift
//  Onboardings
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import Foundation
import WebKit

private extension Onboardings {
    static let webViewEventMessageName = "postEvent"
}

final class OnboardingViewModel: NSObject, ObservableObject {
    let stamp: String
    let url: URL
    var onMessage: ((OnboardingsMessage) -> Void)?
    var onError: ((OnboardingsError) -> Void)?

    init(stamp: String, url: URL) {
        self.stamp = stamp
        self.url = url
    }

    @MainActor
    func configureWebView(_ webView: WKWebView) {
        Log.verbose("#OnboardingViewModel_\(stamp)# configureWebView \(self.url)")

        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: Onboardings.webViewEventMessageName)

        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension OnboardingViewModel: WKNavigationDelegate, WKScriptMessageHandler {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        let url = webView.url?.absoluteString ?? "null"
        Log.verbose("#OnboardingViewModel_\(stamp)# webView didStartProvisionalNavigation url: \(url)")
    }

    public func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        let url = webView.url?.absoluteString ?? "null"
        Log.verbose("#OnboardingViewModel_\(stamp)# webView didFinish navigation url: \(url)")
    }

    public func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        Log.error("#OnboardingViewModel_\(stamp)# didFail navigation withError \(error)")
        onError?(.webKit(error: error))
    }

    public func userContentController(_: WKUserContentController, didReceive wkMessage: WKScriptMessage) {
        do {
            let message = try OnboardingsMessage(chanel: wkMessage.name, body: wkMessage.body)
            Log.verbose("#OnboardingViewModel_\(stamp)# On message: \(message)")
            onMessage?(message)
        } catch let error as OnboardingsUnknownMessageError {
            Log.warn("#OnboardingViewModel_\(stamp)# Unknown message \(error.type.map { "with type \"\($0)\"" } ?? "with name \"\(error.chanel)\""): \(String(describing: wkMessage.body))")
        } catch {
            Log.error("#OnboardingViewModel_\(stamp)# Error on decoding event: \(error)")
        }
    }
}
