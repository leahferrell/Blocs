//
//  Grid.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/7/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import SpriteKit

class Grid: SKNode {
    var blocksLeft = 100
    let playableRect: CGRect!
    let explodeEmitter:SKEmitterNode = SKEmitterNode(fileNamed: "enemyDeath.sks")
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(playableRect: CGRect){
        self.playableRect = playableRect
        super.init()
        setup()
    }
    
    func setup(){
        blocksLeft = 100
        
        let blockSize = CGFloat(72)
        let spaceSize = CGFloat(8)
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
                let block = Block(position: point, blockTypes: 3)
                
                addChild(block)
            }
        }
    }
    
    func removeRemainingBlocks(){
        enumerateChildNodesWithName("block"){ node, _ in
            let block = node as! SKSpriteNode
            block.removeFromParent()
        }
    }
    
    func resetBlocks(){
        removeRemainingBlocks()
        setup()
    }
    
    func hitBlock(block:SKNode){
        blocksLeft--
        explodeEmitter.position = block.position
        if explodeEmitter.parent == nil {
            addChild(explodeEmitter)
        }
        explodeEmitter.resetSimulation()
        block.removeFromParent()
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
}