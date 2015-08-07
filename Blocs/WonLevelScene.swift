//
//  WonLevelScene.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/7/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation
import SpriteKit

class WonLevelScene: SKScene {
    var level:Int
    
    init(size: CGSize, level: Int) {
        self.level = level
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed:"background3")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        level++
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        transitionToLevel()
    }
    
    func transitionToLevel(){
        let block = SKAction.runBlock {
            let myScene = GameScene(size: self.size, level: self.level)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(block)
    }
}