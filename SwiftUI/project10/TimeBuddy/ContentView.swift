//
//  ContentView.swift
//  TimeBuddy
//
//  Created by Paul Hudson on 14/04/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var timeZones = [String]()
    @State private var newTimeZone = "GMT"
    @State private var selectedTimeZones = Set<String>()

    var body: some View {
        VStack {
            if timeZones.isEmpty {
                Text("Please add your first time zone below.")
                    .frame(maxHeight: .infinity)
            } else {
                List(selection: $selectedTimeZones) {
                    ForEach(timeZones, id: \.self) { timeZone in
                        Text(timeZone)
                    }
                    .onMove(perform: moveItems)
                }
                .onDeleteCommand(perform: deleteItems)
            }

            HStack {
                Picker("Add Time Zone", selection: $newTimeZone) {
                    ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self, content: Text.init)
                }

                Button("Add") {
                    if timeZones.contains(newTimeZone) == false {
                        withAnimation {
                            timeZones.append(newTimeZone)
                        }

                        save()
                    }
                }
            }

        }
        .padding()
        .onAppear(perform: load)
    }

    func load() {
        timeZones = UserDefaults.standard.stringArray(forKey: "TimeZones") ?? []
    }

    func save() {
        UserDefaults.standard.set(timeZones, forKey: "TimeZones")
    }

    func deleteItems() {
        withAnimation {
            timeZones.removeAll(where: selectedTimeZones.contains)
        }

        save()
    }

    func moveItems(from source: IndexSet, to destination: Int) {
        timeZones.move(fromOffsets: source, toOffset: destination)
        save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
