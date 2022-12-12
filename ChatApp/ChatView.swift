//
//  ChatView.swift
//  ChatApp
//
//  Created by Marcos Ortiz on 12/12/22.
//

import SwiftUI
import WebKit

public struct ChatView: View {
    @EnvironmentObject
    private var configuration: ChatConfiguration

    public var body: some View {
        WebView(url: configuration.url)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(ChatConfiguration.debug)
    }
}
