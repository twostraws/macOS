//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Review.self)
        }
    }
}
