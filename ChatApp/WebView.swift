//
//  WebView.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/12/22.
//

import SwiftUI
import WebKit

public struct WebView {
    private let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

private extension WebView {
    func makeWebView() -> WKWebView {
        WKWebView()
    }

    func updateWebView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.navigationDelegate = context.coordinator
        webView.load(request)
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
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            navigationAction.navigationType == .linkActivated ? .cancel : .allow
        }
        #endif
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: ChatConfiguration.debug.url)
    }
}
