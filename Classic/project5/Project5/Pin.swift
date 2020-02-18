//
//  Pin.swift
//  Project5
//
//  Created by TwoStraws on 19/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa
import MapKit

class Pin: NSObject, MKAnnotation {
	var title: String?
	var subtitle: String?
	var coordinate: CLLocationCoordinate2D
	var color: NSColor

	init(title: String, coordinate: CLLocationCoordinate2D, color: NSColor = NSColor.green) {
		self.title = title
		self.coordinate = coordinate
		self.color = color
	}
}
