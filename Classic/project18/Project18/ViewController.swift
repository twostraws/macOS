//
//  ViewController.swift
//  Project18
//
//  Created by TwoStraws on 27/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	@objc dynamic var temperatureCelsius: Double = 50 {
		didSet {
			updateFahrenheit()
		}
	}

	@objc dynamic var temperatureFahrenheit: Double = 50

	@objc dynamic var icon: String {
		switch temperatureCelsius {
		case let temp where temp < 0:
			return "⛄️"
		case 0...10:
			return "❄️"
		case 10...20:
			return "☁️"
		case 20...30:
			return "⛅️"
		case 30...40:
			return "☀️"
		case 40...50:
			return "🔥"
		default:
			return "💀"
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		updateFahrenheit()
	}

	@IBAction func reset(_ sender: Any) {
		temperatureCelsius = 50
	}

	override func setNilValueForKey(_ key: String) {
		if key == "temperatureCelsius" {
			temperatureCelsius = 0
		}
	}

	func updateFahrenheit() {
		let celsius = Measurement(value: temperatureCelsius, unit: UnitTemperature.celsius)
		temperatureFahrenheit = round(celsius.converted(to: .fahrenheit).value)
	}

    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if key == "icon" {
            return ["temperatureCelsius"]
        } else {
            return []
        }
    }
}

