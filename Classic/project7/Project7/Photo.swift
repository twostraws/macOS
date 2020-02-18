//
//  Photo.swift
//  Project7
//
//  Created by TwoStraws on 20/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class Photo: NSCollectionViewItem {
	let selectedBorderThickness: CGFloat = 3

	override var highlightState: NSCollectionViewItem.HighlightState {
		didSet {
			if highlightState == .forSelection {
				view.layer?.borderWidth = selectedBorderThickness
			} else {
				if !isSelected {
					view.layer?.borderWidth = 0
				}
			}
		}
	}

	override var isSelected: Bool {
		didSet {
			if isSelected {
				view.layer?.borderWidth = selectedBorderThickness
			} else {
				view.layer?.borderWidth = 0
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.wantsLayer = true
		view.layer?.borderColor = NSColor.blue.cgColor
	}
}
