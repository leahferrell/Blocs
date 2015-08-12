//
//  GameData.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/12/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation

class GameData {
    //store the user's game achievement
    var score:Int = 0 {
        didSet {
            //custom setter - keep the score nonnegative
            score = max(score, 0)
        }
    }
    
    var lives:Int = 5
    
    var level:Int = 1
    
    init(score: Int, lives: Int, level: Int){
        self.score = score
        self.lives = lives
        self.level = level
    }
    
    convenience init(){
        self.init(score: 0, lives: 5, level: 1)
    }
    
    func resetLevel(){
        score = 0
        lives = 5
    }
    
    func resetGame(){
        score = 0
        lives = 5
        level = 1
    }
}
