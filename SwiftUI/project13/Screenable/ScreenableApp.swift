//
//  ScreenableApp.swift
//  Screenable
//
//  Created by Paul Hudson on 14/04/2022.
//

import SwiftUI

@main
struct ScreenableApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ScreenableDocument()) { file in
            ContentView(document: file.$document)
        }
        .commands {
            CommandGroup(after: .saveItem) {
                Button("Export") {
                    NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
                }
                .keyboardShortcut("e")
            }
        }

        Settings(content: SettingsView.init)
    }

    init() {
        let dict = [
            "FontSize": 12,
            "ShadowStrength": 1
        ]

        UserDefaults.standard.register(defaults: dict)
    }
}
