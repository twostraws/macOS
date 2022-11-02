//
//  ContentView.swift
//  Screenable
//
//  Created by Paul Hudson on 14/04/2022.
//

import SwiftUI
import UniformTypeIdentifiers

@MainActor struct ContentView: View {
    @Binding var document: ScreenableDocument

    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
    let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")

    var body: some View {
        HStack(spacing: 20) {
            RenderView(document: document)
                .onDrag {
                    NSItemProvider(item: snapshotToURL() as NSSecureCoding, typeIdentifier: UTType.fileURL.identifier)
                }
                .dropDestination(for: URL.self) { items, location in
                    handleDrop(of: items)
                }

            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Caption")
                        .bold()

                    TextEditor(text: $document.caption)
                        .font(.title)
                        .border(.tertiary, width: 1)

                    Picker("Select a caption font", selection: $document.font) {
                        ForEach(fonts, id: \.self, content: Text.init)
                    }

                    HStack {
                        Picker("Size of caption font", selection: $document.fontSize) {
                            ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self) { size in
                                Text("\(size)pt")
                            }
                        }

                        ColorPicker("Caption color", selection: $document.captionColor)
                    }
                }
                .labelsHidden()

                VStack(alignment: .leading) {
                    Text("Background image")
                        .bold()

                    Picker("Background image", selection: $document.backgroundImage) {
                        Text("No background image").tag("")
                        Divider()

                        ForEach(backgrounds, id: \.self, content: Text.init)
                    }
                }
                .labelsHidden()

                VStack(alignment: .leading) {
                    Text("Background color")
                        .bold()

                    Text("If set to non-transparent, this will be drawn over the background image.")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 20) {
                        ColorPicker("Start:", selection: $document.backgroundColorTop)
                        ColorPicker("End:", selection: $document.backgroundColorBottom)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Drop shadow")
                        .bold()

                    Picker("Drop shadow location", selection: $document.dropShadowLocation) {
                        Text("None").tag(0)
                        Text("Text").tag(1)
                        Text("Device").tag(2)
                        Text("Both").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()

                    Stepper("Shadow radius: \(document.dropShadowStrength)pt", value: $document.dropShadowStrength, in: 1...20)
                }
            }
            .frame(width: 250)
        }
        .padding()
        .toolbar {
            Button("Export") { export() }
            ShareLink(item: snapshotToURL())
        }
        .onCommand(#selector(AppCommands.export)) { export() }
    }

    func snapshotToURL() -> URL {
        let url = URL.temporaryDirectory.appending(path: "ScreenableExport").appendingPathExtension("png")
        try? createSnapshot()?.write(to: url)
        return url
    }
    
    func handleDrop(of urls: [URL]) -> Bool {
        guard let url = urls.first else { return false }
        let loadedImage = try? Data(contentsOf: url)
        document.userImage = loadedImage
        return true
    }

    func export() {
        guard let png = createSnapshot() else { return }

        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]

        panel.begin { result in
            if result == .OK {
                guard let url = panel.url else { return }

                do {
                    try png.write(to: url)
                } catch {
                    print (error.localizedDescription)
                }
            }
        }
    }
    
    func createSnapshot() -> Data? {
        let renderer = ImageRenderer(content: RenderView(document: document))
 
        if let tiff = renderer.nsImage?.tiffRepresentation {
            let bitmap = NSBitmapImageRep(data: tiff)
            return bitmap?.representation(using: .png, properties: [:])
        } else {
            return nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ScreenableDocument()))
    }
}
