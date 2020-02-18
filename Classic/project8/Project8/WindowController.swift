//
//  WindowController.swift
//  Project8
//
//  Created by TwoStraws on 21/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
    
		window?.styleMask = [window!.styleMask, .fullSizeContentView]
		window?.titlebarAppearsTransparent = true
		window?.titleVisibility = .hidden
		window?.isMovableByWindowBackground = true

        window?.backgroundColor = NSColor.clear
    }
}
