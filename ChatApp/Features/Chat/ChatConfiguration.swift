//
//  ChatConfiguration.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/12/22.
//

import SwiftUI

public final class ChatConfiguration: ObservableObject {
    public let chatURL: URL
    public var menuIcon: Image

    public init(
        url: URL,
        menuIcon: Image = Image("openai.icon")
    ) {
        self.chatURL = url
        self.menuIcon = menuIcon
    }

    public var defaultWindowSize: CGSize {
        CGSize(width: 450, height: 600)
    }

    public var githubURL: URL {
        URL(string: "https://github.com/morluna/ChatGPT")!
    }
}

public extension ChatConfiguration {
    static let release = ChatConfiguration(
        url: URL(string: "https://chat.openai.com/chat/")!
    )

    static let debug = ChatConfiguration(
        url: URL(string: "https://www.google.com")!
    )
}
