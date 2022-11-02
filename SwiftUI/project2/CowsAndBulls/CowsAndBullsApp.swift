//
//  CowsAndBullsApp.swift
//  CowsAndBulls
//
//  Created by Paul Hudson on 30/03/2022.
//

import SwiftUI

@main
struct CowsAndBullsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)

        Settings(content: SettingsView.init)
    }
}
