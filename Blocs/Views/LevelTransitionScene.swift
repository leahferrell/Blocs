//
//  LevelTransitionScene.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/12/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation
import SpriteKit

class LevelTransitionScene: SKScene {
    var data: GameData
    
    init(size: CGSize, data: GameData) {
        self.data = data
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed:"background3")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        let levelLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
        levelLabel.text = "Level \(data.level)"
        levelLabel.fontSize = 100
        levelLabel.fontColor = UIColor.whiteColor()
        levelLabel.verticalAlignmentMode = .Center
        levelLabel.zPosition = 100
        levelLabel.position = CGPoint(x:self.size.width/2, y:self.size.height/2-400)
        
        let action = SKAction.sequence([
            SKAction.scaleTo(1.25, duration: 0.2),
            SKAction.scaleTo(1.0, duration: 0.2)])
        
        //levelLabel.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(levelLabel)
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(0.75),
            SKAction.runBlock(){
                self.transitionToLevel()
            }
            ]))
    }
    
    func transitionToLevel(){
        let block = SKAction.runBlock {
            let myScene = GameScene(size: self.size, data: self.data)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(block)
    }
}