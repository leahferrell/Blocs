//
//  GameScene.swift
//  Blocs
//
//  Created by Leah Ferrell on 6/15/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    let scoreLayerNode = SKNode()
    let controllerLayerNode = SKNode()
    let blockLayerNode = SKNode()
    let backgroundLayerNode = SKNode()
    let playableRect:CGRect
    var paddle:Paddle!
    var deltaPoint = CGPointZero
    var previousTouchLocation = CGPointZero
    var scoreLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
    var flashAction:SKAction!
    var livesLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
    var pause = true
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    var score = 0
    var lives = 5
    let explodeEmitter:SKEmitterNode = SKEmitterNode(fileNamed: "enemyDeath.sks")
    var ball:Ball!
    var moveVector = CGVector()
    var exitedPaddle = false
    var exitedSide = true
    var blocksLeft = 0
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize){
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - maxAspectRatioWidth) / 2.0 + 70
        playableRect = CGRect(x: playableMargin, y: 64, width: maxAspectRatioWidth-140, height: size.height-230)
        
        super.init(size: size)
        setupSceneLayers()
        setupUI()
        setupEntities()
    }
    
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
    
    func setupEntities(){
        paddle = Paddle(position: CGPoint(x: size.width/2, y: 100))
        paddle.name = "paddle"
        blockLayerNode.addChild(paddle)
        ball = Ball(position: paddle.position)
        ball.hidden = true
        blockLayerNode.addChild(ball)
        
        //Blocks
        setupBlocks()
    }
    
    func setupBlocks(){
        let blockSize = CGFloat(36)
        let spaceSize = CGFloat(4)
        var point:CGPoint
        var yoffset:CGFloat
        
        for j in 1...10{
            if j == 1{
                yoffset = blockSize
            }
            else{
                yoffset = blockSize * CGFloat(j)+spaceSize*CGFloat(j-1)
            }
            for i in 1...10{
                blocksLeft++
                if i == 1 {
                    point = CGPoint(
                        x: playableRect.minX+blockSize,
                        y: playableRect.maxY-yoffset)
                }
                else{
                    point = CGPoint(
                        x: playableRect.minX+blockSize*CGFloat(i)+spaceSize*(CGFloat(i-1)),
                        y: playableRect.maxY-yoffset)
                }
                let block = Block(position: point)
                block.name = "block"
                blockLayerNode.addChild(block)
            }
        }
    }
    
    func removeRemainingBlocks(){
        enumerateChildNodesWithName("block"){ node, _ in
            let block = node as! SKSpriteNode
            block.removeFromParent()
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //backgroundColor = SKColor.lightGrayColor()
        //debugDrawPlayableArea()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //let touch = touches.first as! UITouch
        for touch:AnyObject in touches {
            let location1 = touch.locationInNode(controllerLayerNode)
            let location2 = touch.locationInNode(blockLayerNode)
            let node1 = self.nodeAtPoint(location1)
            let node2 = self.nodeAtPoint(location2)
            if (pause && node1.name == "boxSprite") {
                removeShootBox(node1)
                shootBall(location2)
            }
            else if (pause && node1.name == "gameOverSprite") {
                resetGame(node1)
            }
        }
    }
    
    func shootBall(pointB: CGPoint){
        let pointA = paddle.position
        let unitVector = (pointB - pointA).normalized()
        moveVector = CGVector(dx: unitVector.x, dy: unitVector.y)
        let shootAction = SKAction.moveBy(moveVector, duration: 0.005)
        ball.position = pointA
        ball.hidden = false
        exitedPaddle = false
        ball.runAction(SKAction.repeatActionForever(shootAction))
    }
    
    func hitBlock(block:SKNode){
        blocksLeft--
        explodeEmitter.position = block.position
        if explodeEmitter.parent == nil {
            blockLayerNode.addChild(explodeEmitter)
        }
        explodeEmitter.resetSimulation()
        block.removeFromParent()
        score += 10
        scoreLabel.text = "Score: \(score)"
        scoreLabel.runAction(flashAction)
    }
    
    func removeShootBox(node:SKNode){
        node.removeAllActions()
        node.removeFromParent()
        pause = false
    }
    
    func displayShootBox(){
        exitedPaddle = false
        exitedSide = true
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
        
        //clickLabel.runAction(SKAction.repeatActionForever(flashAction))
        
        boxSprite.addChild(clickLabel)
        controllerLayerNode.addChild(boxSprite)
    }
    
    func removeGameOver(node:SKNode){
        node.removeAllActions()
        node.removeFromParent()
    }
    
    func resetGame(node:SKNode){
        removeRemainingBlocks()
        setupBlocks()
        removeGameOver(node)
        score = 0
        lives = 5
        scoreLabel.text = "Score: \(score)"
        livesLabel.text = "Lives: \(lives)"
        displayShootBox()
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
    
    func checkHitBlock(){
        let pos = ball.position
        let node = self.nodeAtPoint(pos)
        if node.name == "block" {
            hitBlock(node)
            ball.removeAllActions()
            var newVector = CGVector(dx: moveVector.dx, dy: -1 * moveVector.dy)
            moveVector = newVector
            ball.runAction(SKAction.repeatActionForever(SKAction.moveBy(moveVector, duration: 0.005)))
        }
    }
    
    func checkInBounds(){
        let pos = ball.position
        let margin = ball.frame.height/2
        
        if (pos.x <= playableRect.minX+margin) || (pos.x >= playableRect.maxX-margin) || (pos.y >= playableRect.maxY-margin) {
            if (pos.x <= playableRect.minX+margin) || (pos.x >= playableRect.maxX-margin) {
                if exitedSide {
                    ball.removeAllActions()
                    var newVector = CGVector(dx: -1 * moveVector.dx, dy: moveVector.dy)
                    moveVector = newVector
                    ball.runAction(SKAction.repeatActionForever(SKAction.moveBy(moveVector, duration: 0.005)))
                    exitedSide = false
                }
            }
            if (pos.y >= playableRect.maxY-margin) {
                if exitedSide{
                    ball.removeAllActions()
                    var newVector = CGVector(dx: moveVector.dx, dy: -1 * moveVector.dy)
                    moveVector = newVector
                    ball.runAction(SKAction.repeatActionForever(SKAction.moveBy(moveVector, duration: 0.005)))
                    exitedSide = false
                }
            }
        }
        else{
            exitedSide = true
        }
    }
    
    func checkLostLife(){
        let pos = ball.position
        let margin = ball.frame.height/2
        
        if (pos.y <= playableRect.minY+margin) {
            ball.removeAllActions()
            ball.hidden = true
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
    
    func checkHitPaddle(){
        let pos = ball.position
        let node = self.nodeAtPoint(pos)
        
        if CGRectIntersectsRect(paddle.frame, ball.frame) || node.name == "paddle" {
            if exitedPaddle{
                ball.removeAllActions()
                var newVector = CGVector(dx: moveVector.dx, dy: -1 * moveVector.dy)
                moveVector = newVector
                ball.runAction(SKAction.repeatActionForever(SKAction.moveBy(moveVector, duration: 0.005)))
                exitedPaddle = false
            }
        }
        else{
            exitedPaddle = true
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        var newPoint = CGPoint(x: paddle.position.x + deltaPoint.x, y: paddle.position.y)
        newPoint.x.clamp(
            CGRectGetMinX(playableRect), CGRectGetMaxX(playableRect))
        newPoint.y.clamp(
            CGRectGetMinY(playableRect),CGRectGetMaxY(playableRect))
        paddle.position = newPoint
        deltaPoint = CGPointZero
        if !pause {
            checkInBounds()
            checkLostLife()
            checkHitBlock()
            checkHitPaddle()
        }
        if blocksLeft == 0 {
            displayGameOver("You won!")
        }
    }
}
