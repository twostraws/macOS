//
//  GameScene.swift
//  Project11
//
//  Created by TwoStraws on 23/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	var bubbleTextures = [SKTexture]()
	var currentBubbleTexture = 0

	var bubbles = [SKSpriteNode]()
	var maximumNumber = 1

	var bubbleTimer: Timer!

    override func didMove(to view: SKView) {
		bubbleTextures.append(SKTexture(imageNamed: "bubbleBlue"))
		bubbleTextures.append(SKTexture(imageNamed: "bubbleCyan"))
		bubbleTextures.append(SKTexture(imageNamed: "bubbleGray"))
		bubbleTextures.append(SKTexture(imageNamed: "bubbleGreen"))
		bubbleTextures.append(SKTexture(imageNamed: "bubbleOrange"))
		bubbleTextures.append(SKTexture(imageNamed: "bubblePink"))
		bubbleTextures.append(SKTexture(imageNamed: "bubblePurple"))
		bubbleTextures.append(SKTexture(imageNamed: "bubbleRed"))

		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.gravity = CGVector.zero

		for _ in 1 ... 8 {
			createBubble()
		}

		bubbleTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(createBubble), userInfo: nil, repeats: true)
    }

	@objc func createBubble() {
		let bubble = SKSpriteNode(texture: bubbleTextures[currentBubbleTexture])
		bubble.name = String(maximumNumber)
		bubble.zPosition = 1

		let label = SKLabelNode(fontNamed: "HelveticaNeue-Light")
		label.verticalAlignmentMode = .center
		label.text = bubble.name
		label.color = NSColor.white
		label.fontSize = 64
		label.zPosition = 2
		bubble.addChild(label)

		bubbles.append(bubble)
		addChild(bubble)

        let xPos = Int.random(in: 0..<800)
		let yPos = Int.random(in: 0..<600)
		bubble.position = CGPoint(x: xPos, y: yPos)

        let scale = CGFloat.random(in: 0...1)
		bubble.setScale(max(0.7, scale))

		bubble.alpha = 0
		bubble.run(SKAction.fadeIn(withDuration: 0.5))

		configurePhysics(for: bubble)
		nextBubble()
	}

	func nextBubble() {
		currentBubbleTexture += 1

		if currentBubbleTexture == bubbleTextures.count {
			currentBubbleTexture = 0
		}

        maximumNumber += Int.random(in: 1...3)
		let strMaximumNumber = String(maximumNumber)

		if strMaximumNumber.last! == "6" {
			maximumNumber += 1
		}

		if strMaximumNumber.last! == "9" {
			maximumNumber += 1
		}
	}

	func configurePhysics(for bubble: SKSpriteNode) {
		bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.width / 2)
		bubble.physicsBody?.linearDamping = 0.0
		bubble.physicsBody?.angularDamping = 0.0
		bubble.physicsBody?.restitution = 1.0
		bubble.physicsBody?.friction = 0.0

        let motionX = CGFloat.random(in: -200...200)
        let motionY = CGFloat.random(in: -200...200)

        bubble.physicsBody?.velocity = CGVector(dx: motionX, dy: motionY)
        bubble.physicsBody?.angularVelocity = CGFloat.random(in: 0...1)
	}

	override func mouseDown(with event: NSEvent) {
		let location = event.location(in: self)
		let clickedNodes = nodes(at: location).filter { $0.name != nil }

		guard clickedNodes.count != 0 else { return }

		let lowestBubble = bubbles.min { Int($0.name!)! < Int($1.name!)! }
		guard let bestNumber = lowestBubble?.name else { return }

		for node in clickedNodes {
			if node.name == bestNumber {
				pop(node as! SKSpriteNode)
				return
			}
		}

		// still here?
		createBubble()
		createBubble()
	}

	func pop(_ node: SKSpriteNode) {
		guard let index = bubbles.index(of: node) else { return }
		bubbles.remove(at: index)

		node.physicsBody = nil
		node.name = nil

		let fadeOut = SKAction.fadeOut(withDuration: 0.3)
		let scaleUp = SKAction.scale(by: 1.5, duration: 0.3)
		let group = SKAction.group([fadeOut, scaleUp])

		let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
		node.run(sequence)

		run(SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false))

		if bubbles.count == 0 {
			bubbleTimer.invalidate()
		}
	}	
}
