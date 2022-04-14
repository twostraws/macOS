//
//  GameScene.swift
//  BubbleTrouble
//
//  Created by Paul Hudson on 14/04/2022.
//

import SpriteKit

class GameScene: SKScene {
    var bubbleTextures = [SKTexture]()
    var currentBubbleTexture = 0
    var maximumNumber = 1
    var bubbles = [SKSpriteNode]()
    var bubbleTimer: Timer?

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

        for _ in 1...8 {
            createBubble()
        }

        bubbleTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            self?.createBubble()
        }
    }

    func createBubble() {
        // 1: create a new sprite node from our current texture
        let bubble = SKSpriteNode(texture: bubbleTextures[currentBubbleTexture])

        // 2: give it the stringified version of our current number
        bubble.name = String(maximumNumber)

        // 3: give it a Z-position of 1, so it draws above any background
        bubble.zPosition = 1

        // 4: create a label node with the current number, in nice, bright text
        let label = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        label.text = bubble.name
        label.color = NSColor.white
        label.fontSize = 64

        // 5: make the label center itself vertically and draw above the bubble
        label.verticalAlignmentMode = .center
        label.zPosition = 2

        // 6: add the label to the bubble, then the bubble to the game scene
        bubble.addChild(label)
        addChild(bubble)

        // 7: add the new bubble to our array for later use
        bubbles.append(bubble)

        // 8: make it appear somewhere inside our game scene
        let xPos = Int.random(in: 0 ..< 800)
        let yPos = Int.random(in: 0 ..< 600)
        bubble.position = CGPoint(x: xPos, y: yPos)

        let scale = Double.random(in: 0...1)
        bubble.setScale(max(0.7, scale))

        bubble.alpha = 0
        bubble.run(SKAction.fadeIn(withDuration: 0.5))

        configurePhysics(for: bubble)
        nextBubble()
    }

    func nextBubble() {
        // move on to the next bubble texture
        currentBubbleTexture += 1

        // if we've used all the bubble textures start at the beginning
        if currentBubbleTexture == bubbleTextures.count {
            currentBubbleTexture = 0
        }

        // add a random number between 1 and 3 to `maximumNumber`
        maximumNumber += Int.random(in: 1...3)

        // fix the mystery problem
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

        let motionX = Double.random(in: -200...200)
        let motionY = Double.random(in: -200...200)

        bubble.physicsBody?.velocity = CGVector(dx: motionX, dy: motionY)
        bubble.physicsBody?.angularVelocity = Double.random(in: 0...1)
    }

    override func mouseDown(with event: NSEvent) {
        // find where we clicked in SpriteKit
        let location = event.location(in: self)

        // filter out nodes that don't have a name
        let clickedNodes = nodes(at: location).filter { $0.name != nil }

        // make sure at least one clicked node remains
        guard clickedNodes.count != 0 else { return }

        // find the lowest-numbered bubble on the screen
        let lowestBubble = bubbles.min { Int($0.name!)! < Int($1.name!)! }
        guard let bestNumber = lowestBubble?.name else { return }

        // go through all nodes the user clicked to see if any of them is the best number
        for node in clickedNodes {
            if node.name == bestNumber {
                // they were correct – pop the bubble!
                pop(node as! SKSpriteNode)

                // exit the method so we don't create new bubbles
                return
            }
        }

        // if we're still here it means they were incorrect; create two penalty bubbles
        createBubble()
        createBubble()
    }

    func pop(_ node: SKSpriteNode) {
        guard let index = bubbles.firstIndex(of: node) else { return }
        bubbles.remove(at: index)

        node.physicsBody = nil
        node.name = nil

        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let scaleUp = SKAction.scale(by: 1.5, duration: 0.3)
        scaleUp.timingMode = .easeOut
        let group = SKAction.group([fadeOut, scaleUp])

        let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
        node.run(sequence)

        run(SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false))

        if bubbles.count == 0 {
            bubbleTimer?.invalidate()
        }
    }
}
