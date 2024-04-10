//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Paul Hudson on 10/04/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showingUpcomingOnly = false
    @State private var selection: User?

    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]

    var body: some View {
        NavigationSplitView {
            UsersView(selection: $selection, minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
        } detail: {
            if let selection {
                EditUserView(user: selection)
            } else {
                Text("Select a user")
            }
        }
        .toolbar {
            Button("Add User", systemImage: "plus") {
                let user = User(name: "New User", city: "", joinDate: .now)
                modelContext.insert(user)
                selection = user
            }

            Button("Add Samples", systemImage: "person.3") {
                try? modelContext.delete(model: User.self)

                let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))

                modelContext.insert(first)
                modelContext.insert(second)
                modelContext.insert(third)
                modelContext.insert(fourth)

                let job1 = Job(name: "Organize sock drawer", priority: 3)
                let job2 = Job(name: "Write next album", priority: 4)
                first.jobs?.append(job1)
                first.jobs?.append(job2)

            }

            Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                showingUpcomingOnly.toggle()
            }

            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Sort by Name")
                        .tag([
                            SortDescriptor(\User.name),
                            SortDescriptor(\User.joinDate),
                        ])

                    Text("Sort by Join Date")
                        .tag([
                            SortDescriptor(\User.joinDate),
                            SortDescriptor(\User.name)
                        ])
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
        }
    }
}

#Preview {
    ContentView()
}
