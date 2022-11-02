//
//  StormViewerApp.swift
//  StormViewer
//
//  Created by Paul Hudson on 30/03/2022.
//

import SwiftUI

@main
struct StormViewerApp: App {    
    var body: some Scene {
        Window("Storm Viewer", id: "main") {
            ContentView()
                .onAppear {
                     NSWindow.allowsAutomaticWindowTabbing = false
                 }
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .undoRedo) { }
            CommandGroup(replacing: .pasteboard) { }
        }
    }
}
