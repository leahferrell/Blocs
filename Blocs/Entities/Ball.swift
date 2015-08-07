//
//  Ball.swift
//  Blocks
//
//  Created by Leah Ferrell on 6/15/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint){
        let texture = SKTexture(imageNamed: "Ball")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        //self.xScale = 0.5
        //self.yScale = 0.5
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
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
}
