//
//  WebView.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/12/22.
//

import SwiftUI
import WebKit
import Combine

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
        let webView = WKWebView()

        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateWebView(_ webView: WKWebView, context: Context) {
        webView.navigationDelegate = context.coordinator

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
