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
    
    init(position: CGPoint){
        let randomNum = arc4random_uniform(3) + 1
        let texture = SKTexture(imageNamed: "Block\(randomNum)")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.position = position
        
        self.name = "block"
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.frame.size)
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
