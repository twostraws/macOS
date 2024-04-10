//
//  SettingsView.swift
//  CowsAndBulls
//
//  Created by Paul Hudson on 19/05/2022.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("maximumGuesses") var maximumGuesses = 100
    @AppStorage("answerLength") var answerLength = 4
    @AppStorage("enableHardMode") var enableHardMode = false
    @AppStorage("showGuessCount") var showGuessCount = false

    var body: some View {
        TabView {
            Form {
                TextField("Maximum guesses:", value: $maximumGuesses, format: .number)
                    .help("The maximum number of answers you can submit. Changing this will immediately restart your game.")

                TextField("Answer length:", value: $answerLength, format: .number)
                    .help("The length of the number string to guess. Changing this will immediately restart your game.")

                if answerLength < 3 || answerLength > 8 {
                    Text("Must be between 3 and 8")
                        .foregroundStyle(.red)
                }
            }
            .padding()
            .tabItem {
                Label("Game", systemImage: "number.circle")
            }

            Form {
                Toggle("Enable hard mode", isOn: $enableHardMode)
                    .help("This shows the cows and bulls score for only the most recent guess.")
                Toggle("Show guess count", isOn: $showGuessCount)
                    .help("Adds a footer below your guesses showing the total.")
            }
//            .frame(maxWidth: .infinity)
            .padding()
            .tabItem {
                Label("Advanced", systemImage: "gearshape.2")
            }
        }
        .frame(width: 400)
    }
}

#Preview {
    SettingsView()
}
