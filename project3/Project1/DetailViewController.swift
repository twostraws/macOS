	//
//  DetailViewController.swift
//  Project1
//
//  Created by TwoStraws on 17/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {
	@IBOutlet var imageView: NSImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

	func imageSelected(name: String) {
		imageView.image = NSImage(named: name)
	}
}
