//
//  ChatView.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/12/22.
//

import SwiftUI
import WebKit
import Combine

public struct ChatView: View {
    @Environment(\.openURL)
    private var openURL

    @EnvironmentObject
    private var configuration: ChatConfiguration

    @StateObject
    private var viewModel = ChatViewModel()

    public var body: some View {
        switch viewModel.state {
        case .checkingConnection:
            ProgressView()
                .progressViewStyle(.circular)
        case .disconnected:
            Label("Error.NoInternet.Message", systemImage: "network")
                .font(.headline)
        case .ready:
            chatWebView()
        }
    }
}

private extension ChatView {
    @ViewBuilder
    func chatWebView() -> some View {
        #if os(macOS)
        // On macOS, it's not possible to pull-to-refresh the web content,
        // so this toolbar adds a menu with common options such as
        // Quit, Reload, Open in Browser
        VStack(spacing: .zero) {
            ChatToolbar(
                chatURL: configuration.chatURL,
                githubURL: configuration.githubURL,
                reloadAction: { viewModel.shouldReload = true }
            )

            WebView(url: configuration.chatURL, reload: $viewModel.shouldReload)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .center)
        }
        #else
        WebView(url: configuration.chatURL)
            .ignoresSafeArea()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(ChatConfiguration.debug)
    }
}
