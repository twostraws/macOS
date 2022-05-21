//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
