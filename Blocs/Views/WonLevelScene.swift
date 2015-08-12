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
    
    override func didMoveToView(view: SKView) {
        data.level++
        let myScene = GameScene(size: self.size, data: self.data)
        myScene.scaleMode = self.scaleMode
        self.view?.presentScene(myScene)
    }

}