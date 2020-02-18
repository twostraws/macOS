//
//  WindowController.swift
//  Project4
//
//  Created by TwoStraws on 18/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSTextFieldDelegate {
	@IBOutlet var addressEntry: NSTextField!

    override func windowDidLoad() {
        super.windowDidLoad()
        addressEntry.delegate = self
    
        window?.titleVisibility = .hidden
    }

    override func cancelOperation(_ sender: Any?) {
        window?.makeFirstResponder(self.contentViewController)
    }
}
