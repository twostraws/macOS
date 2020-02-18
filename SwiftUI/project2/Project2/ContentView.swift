//
//  ContentView.swift
//  Project2
//
//  Created by Paul Hudson on 18/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
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

                ForEach(0..<Self.gridSize) { row in
                    HStack {
                        ForEach(0..<Self.gridSize) { column in
                            if self.image(row, column) == "empty" {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 64, height: 64)
                            } else {
                                Button(action: {
                                    self.processAnswer(at: row, column)
                                }) {
                                    Image(self.image(row, column))
                                        .renderingMode(.original)
                                }
                                .buttonStyle(BorderlessButtonStyle())
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
                        self.currentLevel = 1
                        self.isGameOver = false
                        self.createLevel()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(20)
                    .background(Color.blue)
                    .clipShape(Capsule())
                }
                .transition(.scale)
            }
        }
        .onAppear(perform: createLevel)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Start New Game") {
                self.currentLevel = 1
                self.isGameOver = false
                self.createLevel()
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
        if self.image(row, column) == self.images[0] {
            // they clicked the correct animal
            self.currentLevel += 1
            self.createLevel()
        } else {
            // they clicked the wrong animal
            if self.currentLevel > 1 {
                // take the current level down by 1 if we can
                self.currentLevel -= 1
            }

            // create a new layout
            self.createLevel()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
