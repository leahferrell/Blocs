//
//  Paddle.swift
//  Blocs
//
//  Created by Leah Ferrell on 6/15/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import SpriteKit

class Paddle: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint){
        let texture = SKTexture(imageNamed: "paddle")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.xScale = 0.5
        self.yScale = 0.5
        self.position = position
        self.name = "paddle"
        self.physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Paddle
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ball
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
}