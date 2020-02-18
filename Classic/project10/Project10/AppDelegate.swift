//
//  AppDelegate.swift
//  Project10
//
//  Created by TwoStraws on 22/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	var updateDisplayTimer: Timer?
	var fetchFeedTimer: Timer?

	var feed: JSON?
	var displayMode = 0

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let defaultSettings = ["latitude": "51.507222", "longitude": "-0.1275", "apiKey": "", "statusBarOption": "-1", "units": "0"]
		UserDefaults.standard.register(defaults: defaultSettings)

		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(loadSettings), name: Notification.Name("SettingsChanged"), object: nil)

		statusItem.button?.title = "Fetching…"
		statusItem.menu = NSMenu()
		addConfigurationMenuItem()

		loadSettings()
	}

	@objc func loadSettings() {
		displayMode = UserDefaults.standard.integer(forKey: "statusBarOption")
		configureUpdateDisplayTimer()

		fetchFeedTimer = Timer.scheduledTimer(timeInterval: 60 * 5, target: self, selector: #selector(fetchFeed), userInfo: nil, repeats: true)
		fetchFeedTimer?.tolerance = 60

		fetchFeed()
	}

	func addConfigurationMenuItem() {
		let separator = NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: "")
		statusItem.menu?.addItem(separator)
	}

	@objc func showSettings(_ sender: NSMenuItem) {
		updateDisplayTimer?.invalidate()
		
		let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
		guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else { return }

		let popoverView = NSPopover()
		popoverView.contentViewController = vc
		popoverView.behavior = .transient
		popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
	}

	@objc func fetchFeed() {
		let defaults = UserDefaults.standard

		guard let apiKey = defaults.string(forKey: "apiKey") else { return }
		guard !apiKey.isEmpty else {
			statusItem.button?.title = "No API key"
			return
		}

		DispatchQueue.global(qos: .utility).async { [unowned self] in
			let latitude = defaults.double(forKey: "latitude")
			let longitude = defaults.double(forKey: "longitude")

			var dataSource = "https://api.darksky.net/forecast/\(apiKey)/\(latitude),\(longitude)"

			if defaults.integer(forKey: "units") == 0 {
				dataSource += "?units=si"
			}

			guard let url = URL(string: dataSource) else { return }
			guard let data = try? String(contentsOf: url) else {
				DispatchQueue.main.async { [unowned self] in
					self.statusItem.button?.title = "Bad API call"
				}

				return
			}

            let newFeed = JSON(parseJSON: data)

			DispatchQueue.main.async {
				self.feed = newFeed
				self.updateDisplay()
				self.refreshSubmenuItems()
			}
		}
	}

	func updateDisplay() {
		guard let feed = feed else { return }

		var text = "Error"

		switch displayMode {
		case 0:
			// summary text
			if let summary = feed["currently"]["summary"].string {
				text = summary
			}

		case 1:
			// Show current temperature
			if let temperature = feed["currently"]["temperature"].int {
				text = "\(temperature)°"
			}

		case 2:
			// Show chance of rain
			if let rain = feed["currently"]["precipProbability"].double {
				text = "Rain: \(rain * 100)%"
			}

		case 3:
			// Show cloud cover
			if let cloud = feed["currently"]["cloudCover"].double {
				text = "Cloud: \(cloud * 100)%"
			}

		default:
			// This should not be reached
			break
		}

		statusItem.button?.title = text
	}

	func configureUpdateDisplayTimer() {
		guard let statusBarMode = UserDefaults.standard.string(forKey: "statusBarOption") else { return }

		if statusBarMode == "-1" {
			displayMode = 0
			updateDisplayTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeDisplayMode), userInfo: nil, repeats: true)
		} else {
			updateDisplayTimer?.invalidate()
		}
	}

	@objc func changeDisplayMode() {
		displayMode += 1

		if displayMode > 3 {
			displayMode = 0
		}

		updateDisplay()
	}

	func refreshSubmenuItems() {
		guard let feed = feed else { return }
		statusItem.menu?.removeAllItems()

		for forecast in feed["hourly"]["data"].arrayValue.prefix(10) {
			let date = Date(timeIntervalSince1970: forecast["time"].doubleValue)
			let formatter = DateFormatter()
			formatter.timeStyle = .short
			let formattedDate = formatter.string(from: date)

			let summary = forecast["summary"].stringValue
			let temperature = forecast["temperature"].intValue
			let title = "\(formattedDate): \(summary) (\(temperature)°)"

			let menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
			statusItem.menu?.addItem(menuItem)
		}

		statusItem.menu?.addItem(NSMenuItem.separator())
		addConfigurationMenuItem()
	}
}
