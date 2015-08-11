//
//  Ball.swift
//  Blocks
//
//  Created by Leah Ferrell on 6/15/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    let engineEmitter = SKEmitterNode(fileNamed: "engine.sks")
    var superSequence: SKAction!
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(position: CGPoint){
        let texture = SKTexture(imageNamed: "Ball")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())

        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.hidden = true
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        self.physicsBody?.collisionBitMask = PhysicsCategory.Paddle | PhysicsCategory.Block
        self.physicsBody?.fieldBitMask = PhysicsCategory.Field
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Block
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        
        let start = SKAction.runBlock(){
            self.startSuperBall()
        }
        let wait = SKAction.waitForDuration(5.0)
        let stop = SKAction.runBlock(){
            self.stopSuperBall()
        }
        superSequence = SKAction.sequence([start, wait, stop])
    }
    
    func createTail(){
        engineEmitter.position = CGPoint(x: 1, y: -4)
        engineEmitter.name = "engineEmitter"
    }
    
    func superBall(){
        if actionForKey("superball") == nil {
            runAction(superSequence, withKey: "superball")
        }
    }
    
    func startSuperBall(){
        self.physicsBody?.collisionBitMask = PhysicsCategory.Paddle
        
        addChild(engineEmitter)
        var mainScene = scene as! GameScene
        engineEmitter.targetNode = mainScene.blockLayerNode
        
    }
    
    func stopSuperBall(){
        self.physicsBody?.collisionBitMask = PhysicsCategory.Paddle | PhysicsCategory.Block
        removeAllChildren()
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
}
