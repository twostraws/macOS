//
//  ContentView.swift
//  Project3
//
//  Created by Paul Hudson on 18/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

class DetailWindowController<RootView: View>: NSWindowController {
    convenience init(rootView: RootView) {
        let hostingController = NSHostingController(rootView: rootView.frame(width: 300, height: 400))
        let window = NSWindow(contentViewController: hostingController)
        window.setContentSize(NSSize(width: 300, height: 400))
        self.init(window: window)
    }
}

struct DetailView: View {
    var body: some View {
        Text("Second View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WindowShowingContentView: View {
    var body: some View {
        Button("Show New Window") {
            let controller = DetailWindowController(rootView: DetailView())
            controller.window?.title = "New window"
            controller.showWindow(nil)
        }
    }
}

class Commands {
    @IBAction func showSelection(_ sender: Any) { }
}

struct MenuHandlingContentView: View {
    @State private var selection = Set<Int>()

    var body: some View {
        List(0..<4, selection: $selection) { num in
            Text("Row \(num)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onCommand(#selector(Commands.showSelection)) {
            print("Selection: \(self.selection)")
        }
    }
}


struct OnDeleteContentView: View {
    @State private var items = ["Hello", "World"]
    @State private var selection: String? = nil

    var body: some View {
        List(selection: $selection) {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
        }
        .onDeleteCommand {
            print("Delete \(selection)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct HoverContentView: View {
    @State private var isHovering = false

    var body: some View {
        Text("Hello, World!")
            .foregroundColor(isHovering ? Color.green : Color.red)
            .padding()
            .onHover { over in
                self.isHovering = over
            }
    }
}

struct MenuButtonContentView: View {
    var body: some View {
        MenuButton("Options") {
            Button("Order coffee") {
                print("Get me an espresso!")
            }

            Button("Log out") {
                print("TTFN")
            }
        }
        .padding()
    }
}

struct RadioGroupContentView: View {
    @State private var selection = 0

    var body: some View {
        Picker("Select an option", selection: $selection) {
            ForEach(0..<5) { number in
                Text("Option \(number)")
            }
        }
        .pickerStyle(RadioGroupPickerStyle())
        .padding()
    }
}

struct ContentView: View {
    @State private var isEnabled = false
    @State private var birthDate = Date()

    var body: some View {
        VStack {
            Button("Visit Apple") {
                NSWorkspace.shared.open(URL(string: "https://www.apple.com")!)
            }
            .buttonStyle(LinkButtonStyle())
            .padding()

            Toggle(isOn: $isEnabled) {
                Text("Enable the flux capacitor")
            }
            .toggleStyle(SwitchToggleStyle())
            .padding()

            Text("Select your birth date")
            DatePicker("Birth date", selection: $birthDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()

            VStack {
                ForEach(ControlSize.allCases, id: \.self) { size in
                    Button("Click Me") {
                        print("\(size) button pressed")
                    }
                    .controlSize(size)
                }
            }
            .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
