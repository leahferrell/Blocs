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
    let data = GameData()
    let buttonLayer = SKNode()
    let buttonAction:SKAction
    
    let chooseText = "Play Level"
    let startText = "Start"
    let scoresText = "High Scores"
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        self.buttonAction = SKAction.group([
            SKAction.sequence([
                SKAction.scaleTo(1.05, duration: 0.2),
                SKAction.scaleTo(1.0, duration: 0.2)
                ]),
            SKAction.colorizeWithColor(UIColor.grayColor(), colorBlendFactor: 0.5, duration: 0.4)
            ])
        
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed:"background3")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        let point1 = CGPoint(x: size.width/2, y: size.height/2-400)
        let point2 = CGPoint(x: size.width/2, y: size.height/2-600)
        let point3 = CGPoint(x: size.width/2, y: size.height/2-800)
        
        let startButton = BarButton(position: point1, text: startText)
        let chooseButton = BarButton(position: point2, text: chooseText)
        let scoresButton = BarButton(position: point3, text: scoresText)
        
        buttonLayer.addChild(startButton)
        buttonLayer.addChild(chooseButton)
        buttonLayer.addChild(scoresButton)
        addChild(buttonLayer)
    }
    
    func toChooseLevelScene() {
        let block = SKAction.runBlock {
            let myScene = ChooseLevelScene(size: self.size, data: self.data)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(block)
    }
    
    func toStartScene(){
        let myScene = LevelTransitionScene(size: self.size, data: self.data)
        myScene.scaleMode = self.scaleMode
        let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(buttonLayer)
            let node = buttonLayer.nodeAtPoint(location)
            if node.name == chooseText || node.parent?.name == chooseText{
                node.runAction(buttonAction)
                runAction(SKAction.sequence([
                    SKAction.waitForDuration(0.4),
                    SKAction.runBlock(){
                        self.toChooseLevelScene()
                    }
                ]))
            }
            else if node.name == startText || node.parent?.name == startText {
                node.runAction(buttonAction)
                runAction(SKAction.sequence([
                    SKAction.waitForDuration(0.4),
                    SKAction.runBlock(){
                        self.toStartScene()
                    }
                    ]))
            }
            else if node.name == scoresText || node.parent?.name == scoresText {
                node.runAction(buttonAction)
            }
        }

    }
    
}
