//
//  ViewController.swift
//  Project8
//
//  Created by TwoStraws on 21/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	var visualEffectView: NSVisualEffectView!
	var gridViewButtons = [NSButton]()
	var gameOverView: GameOverView!

	var images = ["elephant", "giraffe", "hippo", "monkey", "panda", "parrot", "penguin", "pig", "rabbit", "snake"]
	var currentLevel = 1

	let gridSize = 10
	let gridMargin: CGFloat = 5

    var observer: NSKeyValueObservation?

	override func loadView() {
		super.loadView()

		visualEffectView = NSVisualEffectView()
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		visualEffectView.material = .underWindowBackground
		visualEffectView.state = .active
		view.addSubview(visualEffectView)

		visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		let title = createTitle()
		createGridView(relativeTo: title)
	}

	override func viewDidLoad() {
		createLevel()

        observer = NSApp.observe(\.effectiveAppearance) { (app, _) in
            self.appearanceChanged()
        }
	}

    func appearanceChanged() {
        let darkMode = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        print(darkMode)
    }

	func createTitle() -> NSTextField {
		let titleString = "Odd One Out"
		let title = NSTextField(labelWithString: titleString)
		title.font = NSFont.systemFont(ofSize: 36, weight: .thin)
		title.textColor = NSColor.labelColor
		title.translatesAutoresizingMaskIntoConstraints = false

		visualEffectView.addSubview(title)
		title.topAnchor.constraint(equalTo: visualEffectView.topAnchor, constant: gridMargin).isActive = true
		title.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor).isActive = true

		return title
	}

	func createGridView(relativeTo title: NSTextField) {
		let rows = createButtonArray()
		let gridView = NSGridView(views: rows)

		gridView.translatesAutoresizingMaskIntoConstraints = false
		visualEffectView.addSubview(gridView)

		gridView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor, constant: gridMargin).isActive = true
		gridView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor, constant: -gridMargin).isActive = true
		gridView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: gridMargin).isActive = true
		gridView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor, constant: -gridMargin).isActive = true

		gridView.columnSpacing = gridMargin / 2
		gridView.rowSpacing = gridMargin / 2

		for i in 0 ..< gridSize {
			gridView.row(at: i).height = 64
			gridView.column(at: i).width = 64
		}
	}

	func createButtonArray() -> [[NSButton]] {
		var rows = [[NSButton]]()

		for _ in 0 ..< gridSize {
			var row = [NSButton]()

			for _ in 0 ..< gridSize {
				let button = NSButton(frame: NSRect(x: 0, y: 0, width: 64, height: 64))
				button.setButtonType(.momentaryChange)
				button.imagePosition = .imageOnly
				button.focusRingType = .none
				button.isBordered = false

				button.action = #selector(imageClicked)
				button.target = self

				gridViewButtons.append(button)
				row.append(button)
			}

			rows.append(row)
		}
		
		return rows
	}

	func createLevel() {
		if currentLevel == 9 {
			gameOver()
		} else {
			let numbersOfItems = [0, 5, 15, 25, 35, 49, 65, 81, 100]
			generateLayout(items: numbersOfItems[currentLevel])
		}
	}

	func generateLayout(items: Int) {
		for button in gridViewButtons {
			button.tag = 0
			button.image = nil
		}

		gridViewButtons.shuffle()
		images.shuffle()

		var numUsed = 0
		var itemCount = 1

		let firstButton = gridViewButtons[0]
		firstButton.tag = 2 // correct answer
		firstButton.image = NSImage(named: images[0])

		for i in 1 ..< items {
			let currentButton = gridViewButtons[i]
			currentButton.tag = 1 // wrong answer
			currentButton.image = NSImage(named: images[itemCount])
			numUsed += 1

			if (numUsed == 2) {
				numUsed = 0
				itemCount += 1
			}

			if (itemCount == images.count) {
				itemCount = 1
			}
		}
	}

	func gameOver() {
		gameOverView = GameOverView()
		gameOverView.alphaValue = 0
		gameOverView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(gameOverView)

		gameOverView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		gameOverView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		gameOverView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		gameOverView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		gameOverView.layoutSubtreeIfNeeded()

		gameOverView.startEmitting()

		NSAnimationContext.current.duration = 1
		gameOverView.animator().alphaValue = 1
	}

	@objc func imageClicked(_ sender: NSButton) {
		// ignore invisible buttons
		guard sender.tag != 0 else { return }

		if sender.tag == 1 {
			// wrong
			if currentLevel > 1 {
				currentLevel -= 1
			}

			createLevel()
		} else {
			// correct
			if currentLevel < 9 {
				currentLevel += 1
				createLevel()
			}
		}
	}
}

