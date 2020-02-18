//
//  ViewController.swift
//  Project6
//
//  Created by TwoStraws on 19/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//
import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		createVFL()
		//createAnchors()
		//createStackView()
		//createGridView()
	}

	func makeView(_ number: Int) -> NSView {
		let vw = NSTextField(labelWithString: "View #\(number)")
		vw.translatesAutoresizingMaskIntoConstraints = false
		vw.alignment = .center
		vw.wantsLayer = true
		vw.layer?.backgroundColor = NSColor.cyan.cgColor
		return vw
	}

	func createVFL() {
		let textFields = [
			"view0": makeView(0),
			"view1": makeView(1),
			"view2": makeView(2),
			"view3": makeView(3),
			]

		for (name, textField) in textFields {
			view.addSubview(textField)
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(name)]|", options: [], metrics: nil, views: textFields))
		}

		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view0]-[view1]-[view2]-[view3]|", options: [], metrics: nil, views: textFields))
	}

	func createAnchors() {
		var previous: NSView!
		let views = [makeView(0), makeView(1), makeView(2), makeView(3)]

		for vw in views {
			view.addSubview(vw)
			vw.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
			vw.heightAnchor.constraint(equalToConstant: 88).isActive = true
			vw.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

			if previous != nil {
				// we have a previous view – position us 10 points vertically away from it
				vw.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
			} else {
				// we don't have a previous view - position us against the top edge
				vw.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
			}

			// set the previous view to be the current one, for the next loop iteration
			previous = vw
		}

		previous.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

	func createStackView() {
		let stackView = NSStackView(views: [makeView(0), makeView(1), makeView(2), makeView(3)])
		stackView.distribution = .fillEqually
		stackView.orientation = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)

		for view in stackView.arrangedSubviews {
			view.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .horizontal)
			view.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .vertical)
		}

		stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

	func createGridView() {
		let empty = NSGridCell.emptyContentView

		let gridView = NSGridView(views:
			[
				[makeView(0)],
				[makeView(1), empty, makeView(2)],
				[makeView(3), makeView(4), makeView(5), makeView(6)],
				[makeView(7), empty, makeView(8)],
				[makeView(9)]
			]
		)
		gridView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(gridView)

		gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		gridView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		gridView.row(at: 0).height = 32
		gridView.row(at: 1).height = 32
		gridView.row(at: 2).height = 32
		gridView.row(at: 3).height = 32
		gridView.row(at: 4).height = 32

		gridView.column(at: 0).width = 128
		gridView.column(at: 1).width = 128
		gridView.column(at: 2).width = 128
		gridView.column(at: 3).width = 128

		gridView.row(at: 0).mergeCells(in: NSRange(location: 0, length: 4))
		gridView.row(at: 1).mergeCells(in: NSRange(location: 0, length: 2))
		gridView.row(at: 1).mergeCells(in: NSRange(location: 2, length: 2))
		gridView.row(at: 3).mergeCells(in: NSRange(location: 0, length: 2))
		gridView.row(at: 3).mergeCells(in: NSRange(location: 2, length: 2))
		gridView.row(at: 4).mergeCells(in: NSRange(location: 0, length: 4))

		gridView.row(at: 0).yPlacement = .center
		gridView.row(at: 1).yPlacement = .center
		gridView.row(at: 2).yPlacement = .center
		gridView.row(at: 3).yPlacement = .center
		gridView.row(at: 4).yPlacement = .center
		gridView.column(at: 0).xPlacement = .center
		gridView.column(at: 1).xPlacement = .center
		gridView.column(at: 2).xPlacement = .center
		gridView.column(at: 3).xPlacement = .center
	}
}

