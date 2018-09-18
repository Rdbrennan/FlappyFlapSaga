//
//  HighScoreScene.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 12/14/15.
//  Copyright © 2015 TechYes. All rights reserved.
//

import UIKit
import SpriteKit

class HighScoreScene: SKScene {
    
    var background: SKSpriteNode!
    
    var bronze: SKSpriteNode!
    
    var silver: SKSpriteNode!
    
    var gold: SKSpriteNode!
    
    var rainbow: SKSpriteNode!
    
    var gameover: SKSpriteNode!
    
    var label_score: SKLabelNode!

    var x = GameScene()

    
    override func didMove(to view: SKView){
        
        background = SKSpriteNode(imageNamed: "Night_Background")
        self.background.position = convert(CGPoint(x:157, y:270))
        background.size = CGSize(width: frame.size.width * 1.5, height: frame.size.height * 1.5)
        background.zPosition = 49
        addChild(background)
        
        bronze = SKSpriteNode(imageNamed: "BronzeMedal")
        self.bronze.position = convert(CGPoint(x:50, y:200))
        bronze.zPosition = 49
        addChild(bronze)

        
        silver = SKSpriteNode(imageNamed: "SilverMedal")
        self.silver.position = convert(CGPoint(x:125, y:200))
        silver.zPosition = 49
        addChild(silver)
        
        gold = SKSpriteNode(imageNamed: "GoldMedal")
        self.gold.position = convert(CGPoint(x:200, y:200))
        gold.zPosition = 49
        addChild(gold)
        
        rainbow = SKSpriteNode(imageNamed: "RainbowMedal")
        self.rainbow.position = convert(CGPoint(x:275, y:200))
        rainbow.zPosition = 49
        addChild(rainbow)

        
            
        label_score = SKLabelNode(fontNamed:"Futura-CondensedExtraBold")
        self.label_score.position = convert(CGPoint(x:50, y:145))
        label_score.text = "10"
        label_score.zPosition = 101
        self.addChild(label_score)
        
        label_score = SKLabelNode(fontNamed:"Futura-CondensedExtraBold")
        self.label_score.position = convert(CGPoint(x:125, y:145))
        label_score.text = "20"
        label_score.zPosition = 101
        self.addChild(label_score)
        
        label_score = SKLabelNode(fontNamed:"Futura-CondensedExtraBold")
        self.label_score.position = convert(CGPoint(x:200, y:145))
        label_score.text = "30"
        label_score.zPosition = 101
        self.addChild(label_score)
        
        label_score = SKLabelNode(fontNamed:"Futura-CondensedExtraBold")
        self.label_score.position = convert(CGPoint(x:275, y:145))
        label_score.text = "40"
        label_score.zPosition = 101
        self.addChild(label_score)
        
    }
    
    func convert(_ point: CGPoint)->CGPoint {
        return self.view!.convert(CGPoint(x: point.x, y:self.view!.frame.height-point.y), to:self)
    }

    
}
