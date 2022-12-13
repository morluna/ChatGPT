//
//  ChatToolbar.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/13/22.
//

#if os(macOS)
import SwiftUI

public struct ChatToolbar: View {
    @Environment(\.openURL)
    private var openURL

    private let chatURL: URL
    private let githubURL: URL
    private let reloadAction: () -> Void

    public init(
        chatURL: URL,
        githubURL: URL,
        reloadAction: @escaping () -> Void
    ) {
        self.chatURL = chatURL
        self.githubURL = githubURL
        self.reloadAction = reloadAction
    }

    public var body: some View {
        HStack {
            Menu {
                Button("General.Quit") {
                    NSApplication.shared.terminate(nil)
                }

                Button("General.Reload") {
                    reloadAction()
                }

                Button("General.OpenInBrowser") {
                    openURL(chatURL)
                }

                Divider()

                Button("General.ViewOnGithub") {
                    openURL(githubURL)
                }
            } label: {
                Image(systemName: "gear")
            }
            .menuIndicator(.hidden)
            .menuStyle(.borderedButton)
            .fixedSize()
        }
        .padding(.small)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color.clear)
    }
}

struct ChatToolbar_Previews: PreviewProvider {
    static var previews: some View {
        let configuration: ChatConfiguration = .debug

        ChatToolbar(
            chatURL: configuration.chatURL,
            githubURL: configuration.githubURL,
            reloadAction: {}
        )
    }
}
#endif
