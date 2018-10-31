//
//  AppDelegate.swift
//  Project13
//
//  Created by TwoStraws on 24/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		NSColorPanel.shared.showsAlpha = true
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
}

