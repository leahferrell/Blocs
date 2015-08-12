//
//  TinyButton.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/12/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation
import SpriteKit

class TinyButton: SKSpriteNode {
    let label = SKLabelNode(fontNamed: "Marker Felt Thin")
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(position: CGPoint, text:String){
        let texture = SKTexture(imageNamed: "SmallButton2")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.position = position
        name = text
        
        label.text = text
        label.fontSize = 75
        label.fontColor = UIColor.blackColor()
        label.horizontalAlignmentMode = .Center
        label.verticalAlignmentMode = .Center
        label.position = CGPointZero
        addChild(label)
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
}
