//
//  ViewController.swift
//  Project7
//
//  Created by TwoStraws on 20/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import AVFoundation
import Cocoa

class ViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {
	@IBOutlet var collectionView: NSCollectionView!

	var itemsBeingDragged: Set<IndexPath>?
	var photos = [URL]()

	lazy var photosDirectory: URL = {
		let fm = FileManager.default
		let paths = fm.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		let saveDirectory = documentsDirectory.appendingPathComponent("SlideMark")

		if !fm.fileExists(atPath: saveDirectory.path) {
			try? fm.createDirectory(at: saveDirectory, withIntermediateDirectories: true)
		}

		return saveDirectory
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

        collectionView.registerForDraggedTypes([NSPasteboard.PasteboardType.URL])

		do {
			let fm = FileManager.default
			let files = try fm.contentsOfDirectory(at: photosDirectory, includingPropertiesForKeys: nil)

			for file in files {
				if file.pathExtension == "jpg" || file.pathExtension == "png" {
					photos.append(file)
				}
			}
		} catch {
			print("Set up error")
		}
	}

	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}

	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("Photo"), for: indexPath)
		guard let pictureItem = item as? Photo else { return item }

		let image = NSImage(contentsOf: photos[indexPath.item])
		pictureItem.imageView?.image = image

		return pictureItem
	}

	func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
		return .move
	}

	func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
		itemsBeingDragged = indexPaths
	}

	func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
		itemsBeingDragged = nil
	}

	func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
		return photos[indexPath.item] as NSPasteboardWriting?
	}

	func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
		if let moveItems = itemsBeingDragged?.sorted() {
			// this is an internal drag
			performInternalDrag(with: moveItems, to: indexPath)
		} else {
			// this is an external drag
			let pasteboard = draggingInfo.draggingPasteboard
			guard let items = pasteboard.pasteboardItems else { return true }
			performExternalDrag(with: items, at: indexPath)
		}

		return true
	}

	func performInternalDrag(with items: [IndexPath], to indexPath: IndexPath) {
		var targetIndex = indexPath.item

		for fromIndexPath in items {
			let fromItemIndex = fromIndexPath.item

			if (fromItemIndex > targetIndex) {
				photos.moveItem(from: fromItemIndex, to: targetIndex)
				collectionView.moveItem(at: IndexPath(item: fromItemIndex, section: 0), to: IndexPath(item: targetIndex, section: 0))
				targetIndex += 1
			}
		}


		targetIndex = indexPath.item - 1

		for fromIndexPath in items.reversed() {
			let fromItemIndex = fromIndexPath.item

			if (fromItemIndex < targetIndex) {
				photos.moveItem(from: fromItemIndex, to: targetIndex)
				let targetIndexPath = IndexPath(item: targetIndex, section: 0)
				collectionView.moveItem(at: IndexPath(item: fromItemIndex, section: 0), to: targetIndexPath)
				targetIndex -= 1
			}
		}
	}

	func performExternalDrag(with items: [NSPasteboardItem], at indexPath: IndexPath) {
		let fm = FileManager.default

		for item in items {
            guard let stringURL = item.string(forType: NSPasteboard.PasteboardType.fileURL) else { continue }
			guard let sourceURL = URL(string: stringURL) else { continue }
			let destinationURL = photosDirectory.appendingPathComponent(sourceURL.lastPathComponent)

			do {
				try fm.copyItem(at: sourceURL, to: destinationURL)
			} catch {
				print("Could not copy \(sourceURL)")
			}

			photos.insert(destinationURL, at: indexPath.item)
			collectionView.insertItems(at: [indexPath])
		}
	}

	override func keyUp(with event: NSEvent) {
		guard collectionView.selectionIndexPaths.count > 0 else { return }

		if event.charactersIgnoringModifiers == String(UnicodeScalar(NSDeleteCharacter)!) {
			let fm = FileManager.default

			for indexPath in collectionView.selectionIndexPaths.sorted().reversed() {
				do {
					try fm.trashItem(at: photos[indexPath.item], resultingItemURL: nil)
					photos.remove(at: indexPath.item)
				} catch {
					print("Failed to delete \(photos[indexPath.item])")
				}
			}

			collectionView.animator().deleteItems(at: collectionView.selectionIndexPaths)
		}
	}

	@IBAction func runExport(_ sender: NSMenuItem) {
		let size: CGSize

		if sender.tag == 720 {
			size = CGSize(width: 1280, height: 720)
		} else {
			size = CGSize(width: 1920, height: 1080)
		}

		do {
			try exportMovie(at: size)
		} catch {
			print("Error")
		}
	}

	func exportMovie(at size: NSSize) throws {
		let videoDuration = 8.0
        let timeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: videoDuration, preferredTimescale: 600))

		let savePath = photosDirectory.appendingPathComponent("video.mp4")
		let fm = FileManager.default

		if fm.fileExists(atPath: savePath.path) {
			try fm.removeItem(at: savePath)
		}

		let mutableComposition = AVMutableComposition()
		let videoComposition = AVMutableVideoComposition()
		videoComposition.renderSize = size
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)

		let parentLayer = CALayer()
		parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

		parentLayer.addSublayer(createVideoLayer(in: parentLayer, composition: mutableComposition, videoComposition: videoComposition, timeRange: timeRange))
		parentLayer.addSublayer(createSlideshow(frame: parentLayer.frame, duration: videoDuration))
		parentLayer.addSublayer(createText(frame: parentLayer.frame))

		let instruction = AVMutableVideoCompositionInstruction()
		instruction.timeRange = timeRange
		videoComposition.instructions = [instruction]

		let exportSession = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPresetHighestQuality)!
		exportSession.outputURL = savePath
		exportSession.videoComposition = videoComposition
		exportSession.outputFileType = .mp4

		exportSession.exportAsynchronously { [unowned self] in
			DispatchQueue.main.async {
				self.exportFinished(error: exportSession.error)
			}
		}
	}

	func createVideoLayer(in parentLayer: CALayer, composition: AVMutableComposition, videoComposition: AVMutableVideoComposition, timeRange: CMTimeRange) -> CALayer {
		let videoLayer = CALayer()
		videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)

		let mutableCompositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
		let trackURL = Bundle.main.url(forResource: "black", withExtension:"mp4")!
		let asset = AVAsset(url: trackURL)
        let track = asset.tracks[0]
        try! mutableCompositionVideoTrack?.insertTimeRange(timeRange, of: track, at: .zero)

		return videoLayer
	}

	func createSlideshow(frame: CGRect, duration: CFTimeInterval) -> CALayer {
		let imageLayer = CALayer()
		imageLayer.bounds = frame
		imageLayer.position = CGPoint(x: imageLayer.bounds.midX, y: imageLayer.bounds.midY)
        imageLayer.contentsGravity = .resizeAspectFill

		let fadeAnim = CAKeyframeAnimation(keyPath: "contents")
		fadeAnim.duration = duration
		fadeAnim.isRemovedOnCompletion = false
		fadeAnim.beginTime = AVCoreAnimationBeginTimeAtZero

		var values = [NSImage]()

		for photo in photos {
			if let image = NSImage(contentsOfFile: photo.path) {
				// add each image twice so that we're not constantly animating
				values.append(image)
				values.append(image)
			}
		}

		fadeAnim.values = values
		imageLayer.add(fadeAnim, forKey: nil)

		return imageLayer
	}

	func createText(frame: CGRect) -> CALayer {
        let attrs = [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: NSColor.green]
		let text = NSAttributedString(string: "Copyright © 2017 Hacking with Swift", attributes: attrs)
		let textSize = text.size()

		let textLayer = CATextLayer()
		textLayer.bounds = CGRect(origin: CGPoint.zero, size: textSize)
		textLayer.anchorPoint = CGPoint(x: 1, y: 1)
		textLayer.position = CGPoint(x: frame.maxX - 10, y: textSize.height + 10)
		textLayer.string = text
		textLayer.display() // force the layer to render immediately!

		return textLayer
	}

	func exportFinished(error: Error?) {
		let message: String

		if let error = error  {
			message = "Error: \(error.localizedDescription)"
		} else {
			message = "Success!"
		}

		let alert = NSAlert()
		alert.messageText = message
		alert.runModal()
	}
}

extension Array {
	mutating func moveItem(from: Int, to: Int) {
		let item = self[from]
		self.remove(at: from)

		if to <= from {
			self.insert(item, at: to)
		} else {
			self.insert(item, at: to - 1)
		}
	}
}
