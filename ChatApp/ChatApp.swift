//
//  ChatApp.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/12/22.
//

import SwiftUI

@main
struct ChatApp: App {
    private let configuration: ChatConfiguration = .release

    var body: some Scene {
        #if os(iOS)
        WindowGroup {
            ChatView()
                .environmentObject(configuration)
        }
        #endif

        #if os(macOS)
        MenuBarExtra {
            ChatView()
                .environmentObject(configuration)
                .background(.ultraThinMaterial)
                .frame(
                    width: configuration.defaultWindowSize.width,
                    height: configuration.defaultWindowSize.height
                )
        } label: {
            configuration.menuIcon
        }
        .menuBarExtraStyle(.window)
        #endif
    }
}
