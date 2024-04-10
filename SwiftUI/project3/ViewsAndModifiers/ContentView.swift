//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Paul Hudson on 30/03/2022.
//

import SwiftUI

struct ModifierOrder: View {
    var body: some View {
        Text("Hello, world!")
            .background(.red)
            .frame(width: 200, height: 200)
            .onAppear {
                print(type(of: self.body))
            }
    }
}

struct MultiplePadding: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .background(.red)
            .padding()
            .background(.blue)
            .padding()
            .background(.green)
            .padding()
            .background(.yellow)
    }
}

struct ConditionalModifiers: View {
    @State private var redBackground = false

    var body: some View {
        Button("Hello World") {
            // flip the Boolean between true and false
            redBackground.toggle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(redBackground ? .red : .blue)
    }
}

struct EnvironmentModifiers: View {
    var body: some View {
        VStack {
            Text("Gryffindor")
                .font(.largeTitle)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.title)
    }
}

struct MottoView: View {
    var motto1: some View {
        Text("Draco dormiens")
    }

    let motto2 = Text("nunquam titillandus")

    @ViewBuilder var spells: some View {
        Text("Lumos")
        Text("Obliviate")
    }

    var body: some View {
        VStack {
            motto1
                .background(.red)
            motto2
                .background(.blue)
        }
    }
}

struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(.capsule)
    }
}

struct ViewComposition: View {
    var body: some View {
        VStack(spacing: 10) {
            CapsuleText(text: "First")
                .foregroundStyle(.white)
            CapsuleText(text: "Second")
                .foregroundStyle(.yellow)
        }
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content

            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            Text("R\(row)")
            Text("C\(col)")
        }
    }
}

#Preview {
    ContentView()
}
