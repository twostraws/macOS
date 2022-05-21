//
//  GameScene.swift
//  MatchThree
//
//  Created by Paul Hudson on 18/05/2022.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    var nextBall = GKShuffledDistribution(lowestValue: 0, highestValue: 3)
    var cols = [[Ball]]()

    let ballSize = 50.0
    let ballsPerColumn = 10
    let ballsPerRow = 14

    var currentMatches = Set<Ball>()

    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal

            if let formattedScore = formatter.string(from: score as NSNumber) {
                scoreLabel.text = "Score: \(formattedScore)"
            }
        }
    }

    var timer: SKShapeNode!
    var gameStartTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        // loop over as many columns as we need
        for x in 0 ..< ballsPerRow {
            // create a new column to store these balls
            var col = [Ball]()

            for y in 0 ..< ballsPerColumn {
                // add to this column as many balls as we need
                let ball = createBall(row: y, col: x)
                col.append(ball)
            }

            // add this column to the array of columns
            cols.append(col)
        }

        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 55, y: frame.maxY - 55)
        addChild(scoreLabel)

        timer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 40))
        timer.fillColor = .green
        timer.strokeColor = .clear
        timer.position = CGPoint(x: 545, y: 539)
        addChild(timer)
    }

    func position(for ball: Ball) -> CGPoint {
        let x = 72 + ballSize * Double(ball.col)
        let y = 50 + ballSize * Double(ball.row)
        return CGPoint(x: x, y: y)
    }

    func createBall(row: Int, col: Int, startOffScreen: Bool = false) -> Ball {
        // pick a random ball image
        let ballImages = ["ballBlue", "ballGreen", "ballPurple", "ballRed"]
        let ballImage = ballImages[nextBall.nextInt()]

        // create a new ball, and set its row and column
        let ball = Ball(imageNamed: ballImage)
        ball.row = row
        ball.col = col

        if startOffScreen {
            // animate the ball in
            let finalPosition = position(for: ball)
            ball.position = finalPosition
            ball.position.y += 600

            let action = SKAction.move(to: finalPosition, duration: 0.4)
            ball.run(action)
        } else {
            // place the ball in its final position
            ball.position = position(for: ball)
        }

        // name the ball with its image name
        ball.name = ballImage
        addChild(ball)

        // send the ball back to our caller
        return ball
    }

    func ball(at point: CGPoint) -> Ball? {
        let balls = nodes(at: point).compactMap { $0 as? Ball }
        return balls.first
    }

    func match(ball originalBall: Ball) {
        var checkBalls = [Ball?]()

        // mark that we've matched the current ball
        currentMatches.insert(originalBall)

        // a temporary variable to make this code easier to read
        let pos = originalBall.position

        // attempt to find the balls above, below, to the left, and to the right of our starting ball
        checkBalls.append(ball(at: CGPoint(x: pos.x, y: pos.y - ballSize)))
        checkBalls.append(ball(at: CGPoint(x: pos.x, y: pos.y + ballSize)))
        checkBalls.append(ball(at: CGPoint(x: pos.x - ballSize, y: pos.y)))
        checkBalls.append(ball(at: CGPoint(x: pos.x + ballSize, y: pos.y)))

        // loop over all the non-nil balls
        for case let check? in checkBalls {
            // if we checked this ball already, ignore it
            if currentMatches.contains(check) { continue }

            // if this ball is named the same as our original…
            if check.name == originalBall.name {
                // …match other balls from there
                match(ball: check)
            }
        }
    }

    func destroy(_ ball: Ball) {
        cols[ball.col].remove(at: ball.row)
        ball.removeFromParent()

        if let particles = SKEmitterNode(fileNamed: "Fire") {
            particles.position = ball.position
            addChild(particles)

            let wait = SKAction.wait(forDuration: TimeInterval(particles.particleLifetime))
            let sequence = SKAction.sequence([wait, SKAction.removeFromParent()])
            particles.run(sequence)
        }
    }

    override func mouseDown(with event: NSEvent) {
        // figure out where we were clicked
        let location = event.location(in: self)

        // if there isn't a ball there bail out
        guard let clickedBall = ball(at: location) else { return }

        // clear the `currentMatches` set so we can re-fill it
        isUserInteractionEnabled = false
        currentMatches.removeAll()

        // match the clicked ball, then recursively match all others around it
        match(ball: clickedBall)

        // make sure we remove higher-up balls first
        let sortedMatches = currentMatches.sorted {
            $0.row > $1.row
        }

        // remove all matched balls
        for match in sortedMatches {
            destroy(match)
        }

        // move down any balls that need it
        for (columnIndex, col) in cols.enumerated() {
            for (rowIndex, ball) in col.enumerated() {
                // update this ball's row
                ball.row = rowIndex

                // recalculate its position then move it
                let action = SKAction.move(to: position(for: ball), duration: 0.1)

                ball.run(action) { [weak self] in
                    self?.isUserInteractionEnabled = true
                }
            }

            // loop until this column is full
            while cols[columnIndex].count < ballsPerColumn {
                // create a new ball off screen
                let ball = createBall(row: cols[columnIndex].count, col: columnIndex, startOffScreen: true)

                // append it to this column
                cols[columnIndex].append(ball)
            }
        }

        let newScore = currentMatches.count

        if newScore == 1 {
            // bad move – take away points!
            score -= 1000
        } else if newScore == 2 {
            // meh move; do nothing
        } else {
            // good move – add points depending how many balls they matched
            let scoreToAdd = pow(2, Double(min(newScore, 16)))
            score += Int(scoreToAdd)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if gameStartTime == 0 {
            gameStartTime = currentTime
        }

        let elapsed = (currentTime - gameStartTime)
        let remaining = 100 - elapsed
        timer.xScale = max(0, Double(remaining) / 100)
    }
}
