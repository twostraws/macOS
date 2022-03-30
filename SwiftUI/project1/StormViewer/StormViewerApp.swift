//
//  StormViewerApp.swift
//  StormViewer
//
//  Created by Paul Hudson on 30/03/2022.
//

import SwiftUI

@main
struct StormViewerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
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
