//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Paul Hudson on 30/03/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var answer = ""
    @State private var guess = ""
    @State private var guesses = [String]()
    @State private var isGameOver = false

    @AppStorage("maximumGuesses") var maximumGuesses = 100
    @AppStorage("showGuessCount") var showGuessCount = false
    @AppStorage("answerLength") var answerLength = 4
    @AppStorage("enableHardMode") var enableHardMode = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Enter a guess…", text: $guess)
                    .onSubmit(submitGuess)
                Button("Go", action: submitGuess)
            }
            .padding()

            List(0..<guesses.count, id: \.self) { index in
                let guess = guesses[index]
                let shouldShowResult = (enableHardMode == false) || (enableHardMode && index == 0)

                HStack {
                    Text(guess)
                    Spacer()

                    if shouldShowResult {
                        Text(result(for: guess))
                    }
                }
            }
            .listStyle(.sidebar)

            if showGuessCount {
                Text("Guesses: \(guesses.count)/\(maximumGuesses)")
                    .padding()
            }
        }
        .navigationTitle("Cows and Bulls")
        .alert("You win!", isPresented: $isGameOver) {
            Button("OK", action: startNewGame)
        } message: {
            Text("Congratulations! Click OK to play again.")
        }
        .touchBar {
            HStack {
                Text("Guesses: \(guesses.count)/\(maximumGuesses)")
                    .touchBarItemPrincipal()
                Spacer(minLength: 200)
            }
        }
        .frame(width: 250)
        .frame(minHeight: 300)
        .onAppear(perform: startNewGame)
        .onChange(of: maximumGuesses) { _ in startNewGame() }
        .onChange(of: answerLength) { _ in startNewGame() }
    }

    func submitGuess() {
        guard Set(guess).count == answerLength else { return }
        guard guess.count == answerLength else { return }

        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }

        guesses.insert(guess, at: 0)

        // did the player win?
        if result(for: guess).contains("\(answerLength)b") {
            isGameOver = true
        }

        // clear their guess string
        guess = ""
    }

    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0

        let guessLetters = Array(guess)
        let answerLetters = Array(answer)

        for (index, letter) in guessLetters.enumerated() {
            if letter == answerLetters[index] {
                bulls += 1
            } else if answerLetters.contains(letter) {
                cows += 1
            }
        }

        return "\(bulls)b \(cows)c"
    }


    func startNewGame() {
        guard answerLength >= 3 && answerLength <= 8 else { return }

        guess = ""
        guesses.removeAll()
        answer = ""

        let numbers = (0...9).shuffled()

        for i in 0..<answerLength {
            answer.append(String(numbers[i]))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
