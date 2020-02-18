//
//  ViewController.swift
//  Project12
//
//  Created by TwoStraws on 23/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	var imageView: NSImageView!
	var currentAnimation = 0

	override func viewDidLoad() {
		imageView = NSImageView(image: NSImage(named: "penguin")!)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.frame = CGRect(x: 272, y: 172, width: 256, height: 256)
		view.addSubview(imageView)

		let button = NSButton(title: "Click Me", target: self, action: #selector(animate))
		button.frame = CGRect(x: 10, y: 10, width: 100, height: 30)
		view.addSubview(button)
	}
	
	@objc func animate() {
		switch currentAnimation {
		case 0:
			NSAnimationContext.current.duration = 2
			imageView.animator().alphaValue = 0

		case 1:
			imageView.animator().alphaValue = 1

		case 2:
			NSAnimationContext.current.allowsImplicitAnimation = true
			imageView.alphaValue = 0

		case 3:
			imageView.alphaValue = 1

		case 4:
			imageView.animator().frameCenterRotation = 90

		case 5:
			imageView.animator().frameCenterRotation = 0

		case 6:
			let animation = CABasicAnimation(keyPath: "opacity")
			animation.fromValue = 1
			animation.toValue = 0
			imageView.layer?.add(animation, forKey: nil)

		case 7:
			let animation = CABasicAnimation(keyPath: "opacity")
			animation.fromValue = 1
			animation.toValue = 0
			imageView.layer?.opacity = 0
			imageView.layer?.add(animation, forKey: nil)

		case 8:
			// this will do nothing – layer opacity is still 0!
			imageView.animator().alphaValue = 1

		case 9:
			imageView.layer?.opacity = 1

		case 10:
			let animation = CABasicAnimation(keyPath: "transform.scale")
			animation.fromValue = 1
			animation.toValue = 1.1
			animation.autoreverses = true
			animation.repeatCount = 5
			imageView.layer?.add(animation, forKey: nil)

		case 11:
			let animation = CAKeyframeAnimation(keyPath: "position.y")
			animation.values = [0, 200, 0]
			animation.keyTimes = [0, 0.2, 1]
			animation.duration = 2
			animation.isAdditive = true
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			imageView.layer?.add(animation, forKey: nil)

		case 12:
			NSAnimationContext.runAnimationGroup({ [unowned self] ctx in
				ctx.duration = 1
				self.imageView.animator().isHidden = true
			}, completionHandler: { [unowned self] in
					self.view.layer?.backgroundColor = NSColor.red.cgColor
			})

		case 13:
			self.imageView.isHidden = false
			self.view.layer?.backgroundColor = nil

		default:
			currentAnimation = 0
			animate()
			return
		}
		
		currentAnimation += 1
	}
}

