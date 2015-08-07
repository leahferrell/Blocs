//
//  Block.swift
//  Blocks
//
//  Created by Leah Ferrell on 6/15/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import SpriteKit

class Block: SKSpriteNode {
    let explodeEmitter:SKEmitterNode = SKEmitterNode(fileNamed: "enemyDeath.sks")
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint, blockTypes: UInt32, locked: Bool){
        let randomNum = arc4random_uniform(blockTypes) + 1
        let texture: SKTexture
        let name: String
        let physicsBody: SKPhysicsBody
        if !locked{
            texture = SKTexture(imageNamed: "Block\(randomNum)")
            name = "block"
            physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        }
        else{
            texture = SKTexture(imageNamed: "lockedblock")
            name = "locked"
            physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2)
        }
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.position = position
        self.name = name
        self.physicsBody = physicsBody
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Block
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ball
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
    
    func explode(){
        let mainScene = scene as! GameScene
        explodeEmitter.position = position
        if explodeEmitter.parent == nil {
            mainScene.blockLayerNode.addChild(explodeEmitter)
        }
        explodeEmitter.resetSimulation()
    }
}
