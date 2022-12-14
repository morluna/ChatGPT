//
//  WebView.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/12/22.
//

import SwiftUI
import WebKit
import Combine

/// A wrapper around `WKWebView`. Allows for consumer to trigger a reload event via a `Binding<Bool>`.
public struct WebView {
    private let url: URL
    private let reload: Binding<Bool>?

    public init(url: URL, reload: Binding<Bool>? = nil) {
        self.url = url
        self.reload = reload
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

private extension WebView {
    func makeWebView() -> WKWebView {
        // Create the web view and immediately begin loading our initial URL.
        let webView = WKWebView()

        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateWebView(_ webView: WKWebView, context: Context) {
        // Set the delegate so we can handle redirects (macOS)
        webView.navigationDelegate = context.coordinator

        // If this `updateWebView` was called, it's likely that
        // it was triggered by our `reload` binding property.
        // Here we check if it was set to true by the consumer.
        // If so, reset it immediately and reload the web view.
        Task {
            await MainActor.run {
                if reload?.wrappedValue == true {
                    reload?.wrappedValue = false
                    webView.reload()
                }
            }
        }
    }
}

#if os(macOS)
extension WebView: NSViewRepresentable {
    public func makeNSView(context: Context) -> WKWebView {
        makeWebView()
    }

    public func updateNSView(_ webView: WKWebView, context: Context) {
        updateWebView(webView, context: context)
    }
}
#endif

#if os(iOS)
extension WebView: UIViewRepresentable {
    public func makeUIView(context: Context) -> WKWebView {
        makeWebView()
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        updateWebView(webView, context: context)
    }
}
#endif

public extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        #if os(macOS)
        // On macOS, redirects are limited (not sure why), so to avoid the web view from crashing out,
        // we cancel the request to allow ChatGPT to display the login screen and authentication events (recaptcha)
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            navigationAction.navigationType == .linkActivated ? .cancel : .allow
        }
        #endif
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: ChatConfiguration.debug.chatURL)
    }
}
