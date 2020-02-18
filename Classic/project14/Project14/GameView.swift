//
//  GameView.swift
//  Project14
//
//  Created by TwoStraws on 25/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import SpriteKit

class GameView: SKView {
	override func resetCursorRects() {
		if let targetImage = NSImage(named: "cursor") {
			let cursor = NSCursor(image: targetImage, hotSpot: CGPoint(x: targetImage.size.width / 2, y: targetImage.size.height / 2))
			addCursorRect(frame, cursor: cursor)
		}
	}
}
