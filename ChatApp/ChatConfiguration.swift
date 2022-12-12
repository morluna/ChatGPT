//
//  ChatConfiguration.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/12/22.
//

import SwiftUI

public final class ChatConfiguration: ObservableObject {
    public let url: URL
    public var menuIcon: Image

    public init(
        url: URL,
        menuIcon: Image = Image("openai.icon")
    ) {
        self.url = url
        self.menuIcon = menuIcon
    }

    public var defaultWindowSize: CGSize {
        CGSize(width: 450, height: 600)
    }
}

public extension ChatConfiguration {
    static let release = ChatConfiguration(
        url: URL(string: "https://chat.openai.com/chat/")!
    )

    #if DEBUG
    static let debug = ChatConfiguration(
        url: URL(string: "https://www.google.com")!
    )
    #endif
}
