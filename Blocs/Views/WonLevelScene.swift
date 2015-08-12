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
    var data: GameData
    
    init(size: CGSize, data: GameData) {
        self.data = data
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toNextLevel(){
        let myScene = LevelTransitionScene(size:self.size, data: data)
        myScene.scaleMode = self.scaleMode
        let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    override func didMoveToView(view: SKView) {
        data.level++
        toNextLevel()
    }

}