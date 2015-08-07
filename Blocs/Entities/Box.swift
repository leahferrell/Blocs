//
//  Box.swift
//  Blocks
//
//  Created by Leah Ferrell on 6/15/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import SpriteKit

class Box: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint, playableRect: CGRect){
        let texture = Box.createTexture(playableRect)!
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.position = position
        name = "box"
    }
    
    class func createTexture(playableRect: CGRect) -> SKTexture? {
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            
            let boxSprite = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: playableRect.width, height: playableRect.width))
            boxSprite.anchorPoint = CGPointZero
            boxSprite.position = CGPoint(x: playableRect.minX,y:playableRect.height/2+playableRect.minY-40)
            boxSprite.alpha = 0.5
            
            let clickLabel = SKLabelNode(fontNamed: "Marker Felt Thin")
            clickLabel.text = "Click to play!"
            clickLabel.fontColor = UIColor.blackColor()
            //clickLabel.horizontalAlignmentMode = .Right
            clickLabel.verticalAlignmentMode = .Center
            clickLabel.position = CGPoint(
                x: playableRect.minX+playableRect.width/2,
                y: playableRect.height/2+playableRect.minY-40-playableRect.width/2)
            clickLabel.zPosition = 125
            clickLabel.fontSize = 100
            
            boxSprite.addChild(clickLabel)
            // 5
            let textureView = SKView()
            SharedTexture.texture =
                textureView.textureFromNode(boxSprite)
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
    }
    
    func update(delta: NSTimeInterval){
        //TODO
    }
}

