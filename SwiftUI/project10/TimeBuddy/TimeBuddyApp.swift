//
//  TimeBuddyApp.swift
//  TimeBuddy
//
//  Created by Paul Hudson on 14/04/2022.
//

import SwiftUI

@main
struct TimeBuddyApp: App {
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Label("Time Buddy", systemImage: "person.badge.clock.fill")
        }
        .menuBarExtraStyle(.window)
    }
}
