//
//  ViewController.swift
//  Project13
//
//  Created by TwoStraws on 24/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {
	@IBOutlet var imageView: NSImageView!
	@IBOutlet var caption: NSTextView!
	@IBOutlet var fontName: NSPopUpButton!
	@IBOutlet var fontSize: NSPopUpButton!
	@IBOutlet var fontColor: NSColorWell!

	@IBOutlet var backgroundImage: NSPopUpButton!
	@IBOutlet var backgroundColorStart: NSColorWell!
	@IBOutlet var backgroundColorEnd: NSColorWell!

	@IBOutlet var dropShadowStrength: NSSegmentedControl!
	@IBOutlet var dropShadowTarget: NSSegmentedControl!

	var screenshotImage: NSImage?

	var document: Document {
		let oughtToBeDocument = view.window?.windowController?.document as? Document
		assert(oughtToBeDocument != nil, "Unable to find the document for this view controller.")
		return oughtToBeDocument!
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let recognizer = NSClickGestureRecognizer(target: self, action: #selector(importScreenshot))
		imageView.addGestureRecognizer(recognizer)

		loadFonts()
		loadBackgroundImages()
	}

	override func viewWillAppear() {
		super.viewWillAppear()
		updateUI()
		generatePreview()
	}

	func updateUI() {
		caption.string = document.screenshot.caption
		fontName.selectItem(withTitle: document.screenshot.captionFontName)
		fontSize.selectItem(withTag: document.screenshot.captionFontSize)
		fontColor.color = document.screenshot.captionColor

		if !document.screenshot.backgroundImage.isEmpty {
			backgroundImage.selectItem(withTitle: document.screenshot.backgroundImage)
		}

		backgroundColorStart.color = document.screenshot.backgroundColorStart
		backgroundColorEnd.color = document.screenshot.backgroundColorEnd

		dropShadowStrength.selectedSegment = document.screenshot.dropShadowStrength
		dropShadowTarget.selectedSegment = document.screenshot.dropShadowTarget
	}

	func loadFonts() {
		guard let fontFile = Bundle.main.url(forResource: "fonts", withExtension: nil) else { return }
		guard let fonts = try? String(contentsOf: fontFile) else { return }
		let fontNames = fonts.components(separatedBy: "\n")

		for font in fontNames {
			if font.hasPrefix(" ") {
				let item = NSMenuItem(title: font, action: #selector(changeFontName), keyEquivalent: "")
				item.target = self
				fontName.menu?.addItem(item)
			} else {
				let item = NSMenuItem(title: font, action: nil, keyEquivalent: "")
				item.target = self
				item.isEnabled = false
				fontName.menu?.addItem(item)
			}
		}
	}

	func loadBackgroundImages() {
		let allImages = ["Antique Wood", "Autumn Leaves", "Autumn Sunset", "Autumn by the Lake", "Beach and Palm Tree", "Blue Skies", "Bokeh (Blue)", "Bokeh (Golden)", "Bokeh (Green)", "Bokeh (Orange)", "Bokeh (Rainbow)", "Bokeh (White)", "Burning Fire", "Cherry Blossom", "Coffee Beans", "Cracked Earth", "Geometric Pattern 1", "Geometric Pattern 2", "Geometric Pattern 3", "Geometric Pattern 4", "Grass", "Halloween", "In the Forest", "Jute Pattern", "Polka Dots (Purple)", "Polka Dots (Teal)", "Red Bricks", "Red Hearts", "Red Rose", "Sandy Beach", "Sheet Music", "Snowy Mountain", "Spruce Tree Needles", "Summer Fruits", "Swimming Pool", "Tree Silhouette", "Tulip Field", "Vintage Floral", "Zebra Stripes"]

		for image in allImages {
			let item = NSMenuItem(title: image, action: #selector(changeBackgroundImage), keyEquivalent: "")
			item.target = self

			backgroundImage.menu?.addItem(item)
		}
	}

	@objc func importScreenshot() {
		let panel = NSOpenPanel()
		panel.allowedFileTypes = ["jpg", "png"]

		panel.begin { [unowned self] result in
			if result == .OK {
				guard let imageURL = panel.url else { return }
				self.screenshotImage = NSImage(contentsOf: imageURL)
				self.generatePreview()
			}
		}
	}

	func textDidChange(_ notification: Notification) {
		document.screenshot.caption = caption.string
		generatePreview()
	}

	@objc func changeFontName(_ sender: NSMenuItem) {
		document.screenshot.captionFontName = fontName.titleOfSelectedItem ?? ""
		generatePreview()
	}

	@IBAction func changeFontSize(_ sender: NSMenuItem) {
		document.screenshot.captionFontSize = fontSize.selectedTag()
		generatePreview()
	}

	@IBAction func changeFontColor(_ sender: Any) {
		document.screenshot.captionColor = fontColor.color
		generatePreview()
	}

	@IBAction func changeBackgroundImage(_ sender: Any) {
		if backgroundImage.selectedTag() == 999 {
			document.screenshot.backgroundImage = ""
		} else {
			document.screenshot.backgroundImage = backgroundImage.titleOfSelectedItem ?? ""
		}

		generatePreview()
	}

	@IBAction func changeBackgroundColorStart(_ sender: Any) {
		document.screenshot.backgroundColorStart = backgroundColorStart.color
		generatePreview()
	}

	@IBAction func changeBackgroundColorEnd(_ sender: Any) {
		document.screenshot.backgroundColorEnd = backgroundColorEnd.color
		generatePreview()
	}

	@IBAction func changeDropShadowStrength(_ sender: Any) {
		document.screenshot.dropShadowStrength = dropShadowStrength.selectedSegment
		generatePreview()
	}

	@IBAction func changeDropShadowTarget(_ sender: Any) {
		document.screenshot.dropShadowTarget = dropShadowTarget.selectedSegment
		generatePreview()
	}

	func generatePreview() {
		let image = NSImage(size: CGSize(width: 1242, height: 2208), flipped: false) { [unowned self] rect in
			guard let ctx = NSGraphicsContext.current?.cgContext else { return false }

			self.clearBackground(context: ctx, rect: rect)
			self.drawBackgroundImage(rect: rect)
			self.drawColorOverlay(rect: rect)
			let captionOffset = self.drawCaption(context: ctx, rect: rect)
			self.drawDevice(context: ctx, rect: rect, captionOffset: captionOffset)
			self.drawScreenshot(context: ctx, rect: rect, captionOffset: captionOffset)

			return true
		}

		imageView.image = image
	}

	func clearBackground(context: CGContext, rect: CGRect) {
		context.setFillColor(NSColor.white.cgColor)
		context.fill(rect)
	}

	func drawBackgroundImage(rect: CGRect) {
		// if they chose no background image, bail out
		if backgroundImage.selectedTag() == 999 { return }
		guard let title = backgroundImage.titleOfSelectedItem else { return }
		guard let image = NSImage(named: title) else { return }

		image.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1)
	}

	func drawColorOverlay(rect: CGRect) {
		let gradient = NSGradient(starting: backgroundColorStart.color, ending: backgroundColorEnd.color)
		gradient?.draw(in: rect, angle: -90)
	}

	func drawCaption(context: CGContext, rect: CGRect) -> CGFloat {
		if dropShadowStrength.selectedSegment != 0 {
			if dropShadowTarget.selectedSegment == 0 || dropShadowTarget.selectedSegment == 2 {
				setShadow()
			}
		}

		let string = caption.textStorage?.string ?? ""
		let insetRect = rect.insetBy(dx: 40, dy: 20)

		let captionAttributes = createCaptionAttributes()
		let attributedString = NSAttributedString(string: string, attributes: captionAttributes)
		attributedString.draw(in: insetRect)

		if dropShadowStrength.selectedSegment == 2 {
			if dropShadowTarget.selectedSegment == 0 || dropShadowTarget.selectedSegment == 2 {
				// create a stronger drop shadow by drawing again
				attributedString.draw(in: insetRect)
			}
		}

		// clear the shadow so it doesn't affect other stuff
		let noShadow = NSShadow()
		noShadow.set()

		let availableSpace = CGSize(width: insetRect.width, height: CGFloat.greatestFiniteMagnitude)
		let textFrame = attributedString.boundingRect(with: availableSpace, options: [.usesLineFragmentOrigin, .usesFontLeading])
		return textFrame.height
	}

	func drawDevice(context: CGContext, rect: CGRect, captionOffset: CGFloat) {
		guard let image = NSImage(named: "iPhone") else { return }

		let offsetX = (rect.size.width - image.size.width) / 2
		var offsetY = (rect.size.height - image.size.height) / 2
		offsetY -= captionOffset

		if dropShadowStrength.selectedSegment != 0 {
			if dropShadowTarget.selectedSegment == 1 || dropShadowTarget.selectedSegment == 2 {
				setShadow()
			}
		}

		image.draw(at: CGPoint(x: offsetX, y: offsetY), from: .zero, operation: .sourceOver, fraction: 1)

		if dropShadowStrength.selectedSegment == 2 {
			if dropShadowTarget.selectedSegment == 1 || dropShadowTarget.selectedSegment == 2 {
				// create a stronger drop shadow by drawing again
				image.draw(at: CGPoint(x: offsetX, y: offsetY), from: .zero, operation: .sourceOver, fraction: 1)
			}
		}

		// clear the shadow so it doesn't affect other stuff
		let noShadow = NSShadow()
		noShadow.set()
	}

	func drawScreenshot(context: CGContext, rect: CGRect, captionOffset: CGFloat) {
		guard let screenshot = screenshotImage else { return }
		screenshot.size = CGSize(width: 891, height: 1584)

		let offsetY = 314 - captionOffset
		screenshot.draw(at: CGPoint(x: 176, y: offsetY), from: .zero, operation: .sourceOver, fraction: 1)
	}

	func createCaptionAttributes() -> [NSAttributedString.Key: Any]? {
		let ps = NSMutableParagraphStyle()
		ps.alignment = .center

		let fontSizes: [Int: CGFloat] = [0: 48, 1: 56, 2: 64, 3: 72, 4: 80, 5: 96, 6: 128]
		guard let baseFontSize = fontSizes[fontSize.selectedTag()] else { return nil }

		let selectedFontName = fontName.selectedItem?.title.trimmingCharacters(in: .whitespacesAndNewlines) ?? "HelveticaNeue-Medium"
		guard let font = NSFont(name: selectedFontName, size: baseFontSize) else { return nil }
		let color = fontColor.color

		return [NSAttributedString.Key.paragraphStyle: ps, NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
	}

	func setShadow() {
		let shadow = NSShadow()
		shadow.shadowOffset = CGSize.zero
		shadow.shadowColor = NSColor.black
		shadow.shadowBlurRadius = 50
		shadow.set()
	}

	@IBAction func export(_ sender: Any) {
		guard let image = imageView.image else { return }
		guard let tiffData = image.tiffRepresentation else { return }
		guard let imageRep = NSBitmapImageRep(data: tiffData) else { return }
		guard let png = imageRep.representation(using: .png, properties: [:]) else { return }

		let panel = NSSavePanel()
		panel.allowedFileTypes = ["png"]

		panel.begin { result in
			if result == .OK {
				guard let url = panel.url else { return }

				do {
					try png.write(to: url)
				} catch {
					print (error.localizedDescription)
				}
			}
		}
	}
}

