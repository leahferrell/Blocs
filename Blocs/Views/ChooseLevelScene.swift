//
//  ChooseLevelView.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/12/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation
import SpriteKit

class ChooseLevelScene: SKScene {
    var data:GameData
    var buttonLayer = SKNode()
    let buttonAction:SKAction
    var sceneAction:SKAction!
    let mainMenuText = "<- Main Menu"
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, data: GameData){
        self.data = data
        
        self.buttonAction = SKAction.group([
            SKAction.sequence([
                SKAction.scaleTo(1.05, duration: 0.2),
                SKAction.scaleTo(1.0, duration: 0.2)
                ]),
            SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 0.5, duration: 0.4)
            ])
        
        super.init(size: size)
        
        self.sceneAction = SKAction.sequence([
            SKAction.waitForDuration(0.4),
            SKAction.runBlock(){
                self.sceneTapped()
            }
        ])
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed:"background4")
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        self.addChild(background)
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - maxAspectRatioWidth) / 2.0 + 100
        let playableRect = CGRect(x: playableMargin, y: 190, width: maxAspectRatioWidth-200, height: size.height-400)
        
        generateGrid(playableRect)
        
        let point = CGPoint(x: size.width/2, y: playableRect.minY+200)
    
        let mainMenuButton = BarButton(position: point, text: mainMenuText)
        
        buttonLayer.addChild(mainMenuButton)
        
    }
    
    func debugDrawPlayableArea(playableRect: CGRect){
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4.0
        shape.zPosition = 150
        addChild(shape)
    }
    
    func generateGrid(playableRect: CGRect){
        let blockSize = CGFloat(240)
        let spaceSize = CGFloat(58)
        var point:CGPoint
        var yoffset:CGFloat
        var xoffset:CGFloat
        
        for j in 1...3{
            yoffset = blockSize * CGFloat(j)+spaceSize*CGFloat(j)
            
            for i in 1...3{
                let space = i * j
                xoffset = blockSize * CGFloat(i) + spaceSize * CGFloat(i)
                
                let x = playableRect.minX+xoffset-blockSize/2
                let y = playableRect.maxY-yoffset+blockSize/2
                point = CGPoint(x: x,y: y)
                let button = LevelButton(position: point, level: ((j-1)*3+i))
                buttonLayer.addChild(button)
            }
        }
        addChild(buttonLayer)
    }
    
    func sceneTapped() {
        let myScene = LevelTransitionScene(size:self.size, data: data)
        myScene.scaleMode = self.scaleMode
        let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    func toMainMenu(){
        let myScene = MainMenuScene(size:self.size)
        myScene.scaleMode = self.scaleMode
        let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 0.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(buttonLayer)
            let node = buttonLayer.nodeAtPoint(location)
            if node.name == "levelbutton" {
                var dictionary = node.userData!
                let level:Int = Int(dictionary["level"] as! NSNumber)
                data.level = level
                node.runAction(buttonAction){
                    self.sceneTapped()
                }
            }
            else if node.parent?.name == "levelbutton" {
                let parentNode = node.parent!
                var dictionary = parentNode.userData!
                let level:Int = Int(dictionary["level"] as! NSNumber)
                data.level = level
                parentNode.runAction(buttonAction){
                    self.sceneTapped()
                }
            }
            else if node.name == mainMenuText || node.parent?.name == mainMenuText {
                node.runAction(buttonAction){
                    self.toMainMenu()
                }
                
            }
        }
    }
    
}
