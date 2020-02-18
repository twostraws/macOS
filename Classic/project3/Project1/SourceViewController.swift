//
//  SourceViewController.swift
//  Project1
//
//  Created by TwoStraws on 17/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class SourceViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	@IBOutlet var tableView: NSTableView!

	var pictures = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()

		let fm = FileManager()
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)

		for item in items {
			if item.hasPrefix("nssl") {
				pictures.append(item)
			}
		}
	}

	func numberOfRows(in tableView: NSTableView) -> Int {
		return pictures.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let vw = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
		vw.textField?.stringValue = pictures[row]

		return vw
	}

	func tableViewSelectionDidChange(_ notification: Notification) {
		guard tableView.selectedRow != -1 else { return }
		guard let splitVC = parent as? NSSplitViewController else { return }

		if let detail = splitVC.childViewControllers[1] as? DetailViewController {
			detail.imageSelected(name: pictures[tableView.selectedRow])
		}
	}
}
