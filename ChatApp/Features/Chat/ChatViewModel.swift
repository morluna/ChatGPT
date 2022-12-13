//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/13/22.
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject {
    // MARK: - Types
    enum State: String {
        /// We are checking whether there is a network connection
        case checkingConnection
        /// We have determined that there is a valid connection and we're okay to start trying to load content
        case ready
        /// We are not connected to a valid network
        case disconnected
    }

    private let reachability: Reachability? = try? Reachability()
    private var reachabilityCancellable: AnyCancellable?

    @Published
    public private(set) var state: State = .checkingConnection

    /// This will trigger a refresh of  the `ChatView` which will in turn trigger and
    /// update in the `WebView`. When set to true, this will call the underlying `WKWebView`'s
    /// reload method and then immediately set this back to `false`
    @Published
    public var shouldReload: Bool = false

    init() {
        // Start tracking network connectivity events
        try? reachability?.startNotifier()

        reachabilityCancellable = NotificationCenter.default
            .publisher(for: .reachabilityChanged)
            .compactMap { $0.object as? Reachability }
            .sink { [weak self] in
                guard let self else { return }

                // If we are connected to the network, let's allow the
                // web view to display and begin refreshing the content.
                self.state = $0.isConnected ? .ready : .disconnected
            }
    }

    deinit {
        reachability?.stopNotifier()
    }
}

private extension Reachability {
    var isConnected: Bool {
        connection == .wifi || connection == .cellular
    }
}
