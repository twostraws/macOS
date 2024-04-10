//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Paul Hudson on 10/04/2024.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
