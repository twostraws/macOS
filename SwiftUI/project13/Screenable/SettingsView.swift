//
//  SettingsView.swift
//  Screenable
//
//  Created by Paul Hudson on 14/04/2022.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("Font") var font = "Helvetica Neue"
    @AppStorage("FontSize") var fontSize = 16
    @AppStorage("BackgroundImage") var backgroundImage = ""
    @AppStorage("ShadowStrength") var shadowStrength = 1
    @AppStorage("UseMarkdown") var useMarkdown = false

    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
    let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")

    var body: some View {
        Form {
            Picker("Caption font", selection: $font) {
                ForEach(fonts, id: \.self, content: Text.init)
            }

            Picker("Caption font size", selection: $fontSize) {
                ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self) { size in
                    Text("\(size)pt")
                }
            }

            Picker("Background image", selection: $backgroundImage) {
                Text("No background image").tag("")
                Divider()

                ForEach(backgrounds, id: \.self, content: Text.init)
            }

            Stepper("Default shadow radius: \(shadowStrength)", value: $shadowStrength, in: 1...20)

            Toggle("Enable caption Markdown", isOn: $useMarkdown)
        }
        .padding()
        .frame(width: 400)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
