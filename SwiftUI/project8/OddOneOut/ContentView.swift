//
//  ContentView.swift
//  OddOneOut
//
//  Created by Paul Hudson on 14/04/2022.
//

import SwiftUI

struct ContentView: View {
    static let gridSize = 10

    @State var images = ["elephant", "giraffe", "hippo", "monkey", "panda", "parrot", "penguin", "pig", "rabbit", "snake"]
    @State var layout = Array(repeating: "empty", count: gridSize * gridSize)
    @State var currentLevel = 1
    @State var isGameOver = false

    var body: some View {
        ZStack {
            VStack {
                Text("Odd One Out")
                    .font(.system(size: 36, weight: .thin))
                    .fixedSize()

                ForEach(0..<Self.gridSize, id: \.self) { row in
                    HStack {
                        ForEach(0..<Self.gridSize, id: \.self) { column in
                            if image(row, column) == "empty" {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 64, height: 64)
                            } else {
                                Button {
                                    processAnswer(at: row, column)
                                } label: {
                                    Image(image(row, column))
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
            }
            .opacity(isGameOver ? 0.2 : 1)

            if isGameOver {
                VStack {
                    Text("Game over!")
                        .font(.largeTitle)

                    Button("Play Again") {
                        currentLevel = 1
                        isGameOver = false
                        createLevel()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .buttonStyle(.borderless)
                    .padding(20)
                    .background(.blue)
                    .clipShape(.capsule)
                }
            }

        }
        .onAppear(perform: createLevel)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Start New Game") {
                currentLevel = 1
                isGameOver = false
                createLevel()
            }
        }
    }

    func image(_ row: Int, _ column: Int) -> String {
        layout[row * Self.gridSize + column]
    }

    func generateLayout(items: Int) {
        // remove any existing layouts
        layout.removeAll(keepingCapacity: true)

        // randomize the image order, and consider the first image to be the correct animal
        images.shuffle()
        layout.append(images[0])

        // prepare to loop through the other animals
        var numUsed = 0
        var itemCount = 1

        for _ in 1 ..< items {
            // place the current animal image and add to the counter
            layout.append(images[itemCount])
            numUsed += 1

            // if we already placed two, move to the next animal image
            if (numUsed == 2) {
                numUsed = 0
                itemCount += 1
            }

            // if we placed all the animal images, go back to index 1.
            if (itemCount == images.count) {
                itemCount = 1
            }
        }

        // fill the remainder of our array with empty rectangles then shuffle the layout
        layout += Array(repeating: "empty", count: 100 - layout.count)
        layout.shuffle()
    }

    func createLevel() {
        if currentLevel == 9 {
            withAnimation {
                isGameOver = true
            }
        } else {
            let numbersOfItems = [0, 5, 15, 25, 35, 49, 65, 81, 100]
            generateLayout(items: numbersOfItems[currentLevel])
        }
    }

    func processAnswer(at row: Int, _ column: Int) {
        if image(row, column) == images[0] {
            // they clicked the correct animal
            currentLevel += 1
            createLevel()
        } else {
            // they clicked the wrong animal
            if currentLevel > 1 {
                // take the current level down by 1 if we can
                currentLevel -= 1
            }

            // create a new layout
            createLevel()
        }
    }
}

#Preview {
    ContentView()
}
