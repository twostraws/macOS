//
//  GameView.swift
//  ShootingGallery
//
//  Created by Paul Hudson on 14/04/2022.
//

import Cocoa
import SpriteKit

class GameView: SKView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    override func resetCursorRects() {
        if let targetImage = NSImage(named: "cursor") {
            let cursor = NSCursor(image: targetImage, hotSpot: CGPoint(x: targetImage.size.width / 2, y: targetImage.size.height / 2))
            addCursorRect(frame, cursor: cursor)
        }
    }
}
