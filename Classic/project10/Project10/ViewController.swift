//
//  ViewController.swift
//  Project10
//
//  Created by TwoStraws on 22/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa
import MapKit

class ViewController: NSViewController {
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var apiKey: NSTextField!
	@IBOutlet var statusBarOption: NSPopUpButton!
	@IBOutlet var units: NSSegmentedControl!

	override func viewWillAppear() {
		super.viewWillAppear()

		let defaults = UserDefaults.standard
		let savedLatitude = defaults.double(forKey: "latitude")
		let savedLongitude = defaults.double(forKey: "longitude")
		let savedAPIKey = defaults.string(forKey: "apiKey") ?? ""
		let savedStatusBar = defaults.integer(forKey: "statusBarOption")
		let savedUnits = defaults.integer(forKey: "units")

		apiKey.stringValue = savedAPIKey
		units.selectedSegment = savedUnits

		for menuItem in statusBarOption.menu!.items {
			if menuItem.tag == savedStatusBar {
				statusBarOption.select(menuItem)
			}
		}

		let savedLocation = CLLocationCoordinate2D(latitude: savedLatitude, longitude: savedLongitude)
		addPin(at: savedLocation)
		mapView.centerCoordinate = savedLocation

		let recognizer = NSClickGestureRecognizer(target: self, action: #selector(mapTapped))
		mapView.addGestureRecognizer(recognizer)
	}

	@objc func mapTapped(recognizer: NSClickGestureRecognizer) {
		mapView.removeAnnotations(mapView.annotations)

		let location = recognizer.location(in: mapView)
		let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
		addPin(at: coordinate)
	}

	func addPin(at coordinate: CLLocationCoordinate2D) {
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		annotation.title = "Your location"
		mapView.addAnnotation(annotation)
	}

	override func viewWillDisappear() {
		super.viewWillDisappear()

		let defaults = UserDefaults.standard

		let annotation = mapView.annotations[0]
		defaults.set(annotation.coordinate.latitude, forKey: "latitude")
		defaults.set(annotation.coordinate.longitude, forKey: "longitude")
		defaults.set(apiKey.stringValue, forKey: "apiKey")
		defaults.set(units.selectedSegment, forKey: "units")

		var statusBarValue = -1

		for menuItem in statusBarOption.menu!.items {
			if menuItem.state == .on {
				statusBarValue = menuItem.tag
				break
			}
		}

		defaults.set(statusBarValue, forKey: "statusBarOption")

		let nc = NotificationCenter.default
		nc.post(name: Notification.Name("SettingsChanged"), object: nil)
	}

	@IBAction func showPoweredBy(_ sender: Any) {
		NSWorkspace.shared.open(URL(string: "https://darksky.net/poweredby/")!)
	}
}

