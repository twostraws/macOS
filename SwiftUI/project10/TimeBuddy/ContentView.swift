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
    @State private var id = UUID()
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: quit) {
                    Label("Quit", systemImage: "xmark.circle.fill")
                }
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
            
            if timeZones.isEmpty {
                Text("Please add your first time zone below.")
                    .frame(maxHeight: .infinity)
            } else {
                List(selection: $selectedTimeZones) {
                    ForEach(timeZones, id: \.self) { timeZone in
                        let time = timeData(for: timeZone)
                        
                        HStack {
                            Button {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(time, forType: .string)
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                                    .labelStyle(.iconOnly)
                            }
                            .buttonStyle(.borderless)
                            
                            Text(time)
                        }
                    }
                    .onMove(perform: moveItems)
                }
                .onDeleteCommand(perform: deleteItems)
                .contextMenu(forSelectionType: String.self, menu: { _ in }) { timeZones in
                    NSPasteboard.general.clearContents()
                    
                    let timeData = timeZones.map(timeData).sorted().joined(separator: "\n")
                    NSPasteboard.general.setString(timeData, forType: .string)
                }
            }
            
            HStack {
                Picker("Add Time Zone", selection: $newTimeZone) {
                    ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self, content: Text.init)
                }

                Button("Add") {
                    if timeZones.contains(newTimeZone) == false {
                        timeZones.append(newTimeZone)
                    }
                    
                    save()
                }
                .id(id)
            }
        }
        .padding()
        .onAppear(perform: load)
        .frame(height: 300)
        .onReceive(timer) { _ in
            if NSApp.keyWindow?.isVisible == true {
                id = UUID()
            }
        }
    }
    
    func load() {
        timeZones = UserDefaults.standard.stringArray(forKey: "TimeZones") ?? []
    }

    func save() {
        UserDefaults.standard.set(timeZones, forKey: "TimeZones")
    }

    func timeData(for zoneName: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone(identifier: zoneName) ?? .current
        return "\(zoneName): \(dateFormatter.string(from: .now))"
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
    
    func quit() {
        NSApp.terminate(nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
