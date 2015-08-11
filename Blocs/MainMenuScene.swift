//
//  MainMenuScene.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/7/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    let levelLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
    let levelStart = 4
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed:"background3")
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        self.addChild(background)
        
        levelLabel.text = "Level \(levelStart)"
        levelLabel.fontSize = 100
        levelLabel.fontColor = UIColor.whiteColor()
        levelLabel.verticalAlignmentMode = .Center
        levelLabel.zPosition = 100
        levelLabel.position = CGPoint(x:self.size.width/2, y:self.size.height/2-400)
        
        let action = SKAction.sequence([
            SKAction.scaleTo(1.25, duration: 0.2),
            SKAction.scaleTo(1.0, duration: 0.2)])
        
        levelLabel.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(levelLabel)
        
    }
    
    func sceneTapped() {
        levelLabel.removeAllActions()
        

        let shrinkAction = SKAction.scaleTo(0.25, duration: 0.5)
        let spinAction = SKAction.rotateByAngle(6.28, duration: 0.5)
        let fadeAction = SKAction.fadeAlphaTo(0.0, duration: 0.5)

        let concurrentAction = SKAction.group([shrinkAction, spinAction, fadeAction])
        
        levelLabel.runAction(SKAction.sequence([
            concurrentAction,
            SKAction.hide()
            ]))
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(0.5),
            SKAction.runBlock(){
                let myScene = GameScene(size:self.size, level: self.levelStart)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.crossFadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
            ]))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        sceneTapped()
    }
    
}
