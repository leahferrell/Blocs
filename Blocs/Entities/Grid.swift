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
    var blockTypes:UInt32 = 3
    var level = 1
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(playableRect: CGRect, level: Int){
        self.playableRect = playableRect
        super.init()
        
        if level < 10 {
            self.level = level
        }
        
        generateGrid()
    }
    
    func determineBlockTypes(level: Int){
        self.blockTypes = 4
    }
    
    func generateGrid(){
        let blockCodes = blockCodesFromFileNamed("level\(level)")!
        
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
                let space = i * j
                
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
                
                let code:Character = blockCodes[j-1][i-1]
                
                var block = blockForCode(code, pos: point)
                
                addChild(block!)
            }
        }
        
    }
    
    func blockForCode(code: Character, pos: CGPoint) -> Block? {
        var block: Block?
        switch code {
        case "1":
            block = Block.colorBlock(pos, color: 1)
        case "2":
            block = Block.colorBlock(pos, color: 2)
        case "3":
            block = Block.colorBlock(pos, color: 3)
        case "4":
            block = Block.colorBlock(pos, color: 4)
        case "5":
            block = Block.colorBlock(pos, color: 5)
        case "6":
            block = Block.colorBlock(pos, color: 6)
        case "i":
            block = Block.itemBlock(pos)
        case "l":
            blocksLeft--
            block = Block.lockedBlock(pos)
        case "f":
            blocksLeft--
            block = Block.fieldLockedBlock(pos)
        default:
            block = Block.randomColorBlock(pos, blockTypes: 3)
        }
        
        return block
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