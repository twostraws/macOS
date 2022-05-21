//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
                    dataController.save()
                }
        }
    }
}
