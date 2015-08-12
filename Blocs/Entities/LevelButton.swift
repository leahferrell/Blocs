//
//  Button.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/12/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation
import SpriteKit

class LevelButton: SKSpriteNode {
    var level:Int
    let label = SKLabelNode(fontNamed: "Marker Felt Thin")
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(position: CGPoint, level: Int){
        self.level = level
        let texture = SKTexture(imageNamed: "Button")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.position = position
        name = "levelbutton"
        var data = NSMutableDictionary()
        data["level"] = level
        userData = data
                
        label.text = "\(level)"
        label.fontSize = 100
        label.fontColor = UIColor.whiteColor()
        label.horizontalAlignmentMode = .Center
        label.verticalAlignmentMode = .Center
        label.position = CGPointZero
        addChild(label)
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
}
