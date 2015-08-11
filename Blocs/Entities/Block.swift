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
    //var item: Item?
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(position: CGPoint, texture: SKTexture, physicsBody: SKPhysicsBody, name: String){
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = name
        self.position = position
        self.physicsBody = physicsBody
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Block
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ball
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
    
    class func randomColorBlock(position: CGPoint, blockTypes: UInt32) -> Block {
        let randomNum = arc4random_uniform(blockTypes) + 1
        let texture = SKTexture(imageNamed: "Block\(randomNum)")
        let physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        let name = "block"
        
        return Block(position: position, texture: texture, physicsBody: physicsBody, name: name)
    }
    
    class func colorBlock(position: CGPoint, color: Int) -> Block {
        let texture = SKTexture(imageNamed: "Block\(color)")
        let physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        let name = "block"
        
        return Block(position: position, texture: texture, physicsBody: physicsBody, name: name)
    }
    
    class func lockedBlock(position: CGPoint) -> Block {
        let texture = SKTexture(imageNamed: "lockedblock")
        let physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2)
        let name = "locked"
        return Block(position: position, texture: texture, physicsBody: physicsBody, name: name)
    }
    
    class func fieldLockedBlock(position: CGPoint) -> Block {
        let texture = SKTexture(imageNamed: "lockedblock")
        let physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2)
        let name = "locked"
        let block = Block(position: position, texture: texture, physicsBody: physicsBody, name: name)
        
        let field = SKFieldNode.radialGravityField()
        field.strength = 6
        field.enabled = true
        field.categoryBitMask = PhysicsCategory.Field
        block.addChild(field)
        
        return block
    }
    
    class func itemBlock(position: CGPoint) -> Block {
        let randomNum = arc4random_uniform(3) + 1
        let texture = SKTexture(imageNamed: "item")
        let physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        let name = "item"
        
        let block = Block(position: position, texture: texture, physicsBody: physicsBody, name: name)
        block.physicsBody?.categoryBitMask = PhysicsCategory.None
        
        return block
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
