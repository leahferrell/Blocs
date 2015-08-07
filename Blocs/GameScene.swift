//
//  GameScene.swift
//  Blocs
//
//  Created by Leah Ferrell on 6/15/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let scoreLayerNode = SKNode()
    let controllerLayerNode = SKNode()
    let blockLayerNode = SKNode()
    let backgroundLayerNode = SKNode()
    
    let playableRect:CGRect
    
    var paddle:Paddle!
    var ball:Ball!
    var blockGrid:Grid!
    
    var deltaPoint = CGPointZero
    var previousTouchLocation = CGPointZero
    
    var scoreLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
    var livesLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
    
    var flashAction:SKAction!
    
    var pause = true
    var score = 0
    var lives = 5
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize){
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - maxAspectRatioWidth) / 2.0 + 70
        playableRect = CGRect(x: playableMargin, y: 64, width: maxAspectRatioWidth-140, height: size.height-230)
        
        super.init(size: size)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody?.friction = 0.0
        
        setupSceneLayers()
        setupUI()
        setupEntities()
    }
    
    // ********************** Start of Setup Functions
    func setupSceneLayers(){
        scoreLayerNode.zPosition = 100
        controllerLayerNode.zPosition = 120
        blockLayerNode.zPosition = 50
        backgroundLayerNode.zPosition = 0
        
        addChild(scoreLayerNode)
        addChild(controllerLayerNode)
        addChild(blockLayerNode)
        addChild(backgroundLayerNode)
    }
    
    func setupUI(){
        let background = SKSpriteNode(imageNamed: "background6")
        background.xScale = 0.5
        background.yScale = 0.5
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundLayerNode.addChild(background)
        
        //HUD
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: \(score)"
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.position = CGPoint(
            x: size.width / 3,
            y: size.height - (scoreLabel.frame.size.height*2) + 3)
        scoreLayerNode.addChild(scoreLabel)
        
        flashAction = SKAction.sequence([
            SKAction.scaleTo(1.25, duration: 0.2),
            SKAction.scaleTo(1.0, duration: 0.2)])
        
        livesLabel.fontSize = 50
        livesLabel.text = "Lives: \(lives)"
        livesLabel.name = "livesLabel"
        livesLabel.fontColor = SKColor.blackColor()
        livesLabel.verticalAlignmentMode = .Center
        livesLabel.position = CGPoint(
            x: 2 * size.width / 3,
            y: size.height - (scoreLabel.frame.size.height*2) + 3)
        scoreLayerNode.addChild(livesLabel)
        
        //Control Box Thing
        displayShootBox()
        
    }
    
    func setupEntities(){
        paddle = Paddle(position: CGPoint(x: size.width/2, y: 100))
        ball = Ball(position: paddle.position)
        blockGrid = Grid(playableRect: playableRect)
        
        blockLayerNode.addChild(paddle)
        blockLayerNode.addChild(ball)
        blockLayerNode.addChild(blockGrid)
        
    }
    // ********************** End of Setup Functions
    
    
    // ********************** Start of Debug Functions
    func debugDrawPlayableArea(){
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4.0
        shape.zPosition = 150
        addChild(shape)
    }
    // ********************** End of Debug Functions
    
    
    // ********************** Start of Reset Functions
    func resetGame(node:SKNode){
        blockGrid.resetBlocks()
        removeGameOver(node)
        score = 0
        lives = 5
        scoreLabel.text = "Score: \(score)"
        livesLabel.text = "Lives: \(lives)"
        displayShootBox()
    }
    // ********************** End of Reset Functions
    
    
    // ********************** Start of Pop-up Panels Functions
    func removeShootBox(node:SKNode){
        node.removeAllActions()
        node.removeFromParent()
        pause = false
    }
    
    func displayShootBox(){
        pause = true
        let boxSprite = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: playableRect.width, height: playableRect.width))
        boxSprite.anchorPoint = CGPointZero
        boxSprite.position = CGPoint(x: playableRect.minX,y:playableRect.height/2+playableRect.minY-40)
        boxSprite.alpha = 0.5
        boxSprite.name = "boxSprite"
        
        let clickLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
        clickLabel.text = "Tap to shoot!"
        clickLabel.fontColor = UIColor.blackColor()
        clickLabel.position = CGPoint(x: boxSprite.frame.width / 2, y: boxSprite.frame.height/2)
        clickLabel.zPosition = 125
        clickLabel.fontSize = 50
        
        clickLabel.runAction(SKAction.repeatActionForever(flashAction))
        
        boxSprite.addChild(clickLabel)
        
        controllerLayerNode.addChild(boxSprite)
    }
    
    func displayGameOver(text:String){
        let boxSprite = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: playableRect.width, height: playableRect.width))
        boxSprite.anchorPoint = CGPointZero
        boxSprite.position = CGPoint(x: playableRect.minX,y:playableRect.height/2+playableRect.minY-40)
        boxSprite.alpha = 0.5
        boxSprite.name = "gameOverSprite"
        
        let clickLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
        clickLabel.text = text
        clickLabel.fontColor = UIColor.blackColor()
        clickLabel.position = CGPoint(x: boxSprite.frame.width / 2, y: boxSprite.frame.height/2)
        clickLabel.zPosition = 125
        clickLabel.fontSize = 50
        
        boxSprite.addChild(clickLabel)
        controllerLayerNode.addChild(boxSprite)
    }
    
    func removeGameOver(node:SKNode){
        node.removeAllActions()
        node.removeFromParent()
    }
    // ********************** End of Pop-up Panels Functions
    
    
    // ********************** Start of Movement Mechanics Functions
    func shootBall(pointB: CGPoint){
        let pointA = paddle.position + CGPoint(x: 0, y: paddle.frame.height/2)
        let vectorPoint = (pointB - pointA)
        let moveVector = CGVector(dx: vectorPoint.x, dy: vectorPoint.y)
        
        ball.physicsBody?.applyForce(moveVector)
        
        ball.position = pointA
        ball.hidden = false
    }
    
    func hitBlock(block:SKNode){
        blockGrid.hitBlock(block)
        score += 10
        scoreLabel.text = "Score: \(score)"
        scoreLabel.runAction(flashAction)
    }
    // ********************** End of Movement Mechanics Functions
    
    
    // ********************** Start of Touch Functions
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(controllerLayerNode)
            let node = self.nodeAtPoint(location)
            if (pause && node.name == "boxSprite") {
                removeShootBox(node)
                shootBall(location)
            }
            else if (pause && node.name == "gameOverSprite") {
                resetGame(node)
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let currentPoint = touch.locationInNode(self)
        previousTouchLocation = touch.previousLocationInNode(self)
        deltaPoint = currentPoint - previousTouchLocation
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        deltaPoint = CGPointZero
    }
    
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
        deltaPoint = CGPointZero
    }
    // ********************** End of Touch Functions
    
    
    // ********************** Start of Physics Delegate Functions
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "block" {
            hitBlock(contact.bodyA.node!)
        }
        else if contact.bodyB.node?.name == "block" {
            hitBlock(contact.bodyB.node!)
        }
    }
    // ********************** End of Physics Delegate Functions
    
    
    // ********************** Start of Update Loop Functions
    func checkLostLife(){
        let pos = ball.position
        let margin = ball.frame.height/2
        
        if (pos.y <= paddle.frame.minY) {
            ball.removeAllActions()
            ball.hidden = true
            ball.physicsBody?.resting = true
            pause = true
            lives--
            livesLabel.text = "Lives: \(lives)"
            if lives > 0 {
                displayShootBox()
            }
            else{
                displayGameOver("Game Over...")
            }
        }
    }
    
    func checkWin(){
        if blockGrid.blocksLeft == 0 {
            pause = true
            ball.hidden = true
            ball.physicsBody?.resting = true
            displayGameOver("You won!")
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        var newPoint = CGPoint(x: paddle.position.x + deltaPoint.x, y: paddle.position.y)
        newPoint.x.clamp(
            CGRectGetMinX(playableRect), CGRectGetMaxX(playableRect))
        newPoint.y.clamp(
            CGRectGetMinY(playableRect),CGRectGetMaxY(playableRect))
        paddle.position = newPoint
        deltaPoint = CGPointZero
        
        if !pause {
            checkLostLife()
            checkWin()
        }
    }
    // ********************** End of Update Loop Functions
}
