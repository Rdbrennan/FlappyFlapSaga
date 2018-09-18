//
//  FlappyFlapIntro.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/12/15.
//  Copyright © 2015 TechYes. All rights reserved.
//

import SpriteKit
import UIKit
import iAd
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class FlappyFlapIntro: SKScene, SKPhysicsContactDelegate, ADBannerViewDelegate{
    
    // Background
    var background: SKNode!
    let background_speed = 125.0
    
    //Sun Icon
    var sunIcon: SKSpriteNode!
    var sunIcon2: SKSpriteNode!
    
    //FlappyFlap Logo
    var FlappyFlapLogo: SKSpriteNode!
    
    // Bird
    var bird: SKSpriteNode!
    
    // Physics Categories
    let FSBoundaryCategory: UInt32 = 1 << 0
    let FSPlayerCategory: UInt32   = 1 << 1
    let FSPipeCategory: UInt32     = 1 << 2
    let FSGapCategory: UInt32      = 1 << 3
    
    // Time Values
    var delta = TimeInterval(0)
    var last_update_time = TimeInterval(0)
    
    // Game States
    enum FSGameState: Int {
        case fsGameStateStarting
        case fsGameStatePlaying
        case fsGameStateEnded
    }

    var state = FSGameState.fsGameStateStarting

    // MARK: - SKScene Initializacion
    override func didMove(to view: SKView){
        initBackground()
        initBird()

        // Do any additional setup after loading the view.
    }

    func initBackground() {

        background = SKNode()
        addChild(background)
        
        sunIcon = SKSpriteNode(imageNamed: "Sun-icon")
        self.sunIcon.position = convert(CGPoint(x:157, y:350))
        sunIcon.zPosition = 49
        addChild(sunIcon)
        
        
        sunIcon2 = SKSpriteNode(imageNamed: "sun-icon2")
        self.sunIcon2.position = convert(CGPoint(x:157, y:151))
        sunIcon2.zPosition = 49
        addChild(sunIcon2)
        
        FlappyFlapLogo = SKSpriteNode(imageNamed: "FlappyFlapLogo")
        self.FlappyFlapLogo.position = convert(CGPoint(x:159, y:349))
        FlappyFlapLogo.zPosition = 50
        addChild(FlappyFlapLogo)
        
        for i in 0...10{
            let tile1 = SKSpriteNode(imageNamed: "background2")
            tile1.anchorPoint = CGPoint.zero
            tile1.size.height = self.size.height
            tile1.position = convert(CGPoint(x: CGFloat(i) * 640.0, y: 0.0))
            tile1.name = "background2"
            tile1.zPosition = 15
            background.addChild(tile1)
        }
        
        for i in 0...500{
            let tile = SKSpriteNode(imageNamed: "ground")
            tile.anchorPoint = CGPoint.zero
            tile.position = CGPoint(x: CGFloat(i) * 640.0, y: 0.0)
            tile.name = "ground"
            tile.zPosition = 15
            background.addChild(tile)
        }
    }
    
    func moveBackground() {
        let posX = -background_speed * delta

        background.position = CGPoint(x: background.position.x + CGFloat(posX), y: 0.0)

        background.enumerateChildNodes(withName: "background2") { (node, stop) in
            let background_screen_position = self.background.convert(node.position, to: self)
            if background_screen_position.x <= -node.frame.size.width {
                node.position = CGPoint(x: node.position.x + (node.frame.size.width * 2), y: node.position.y)
            }
        }
    }
    
    func initBird() {
        bird = SKSpriteNode(imageNamed: "waterflap1copy@2x")
        self.bird.position = convert(CGPoint(x:275, y:350))
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2.5)
        bird.physicsBody?.categoryBitMask = FSPlayerCategory
        bird.physicsBody?.contactTestBitMask = FSPipeCategory | FSGapCategory | FSBoundaryCategory
        bird.physicsBody?.collisionBitMask = FSPipeCategory | FSBoundaryCategory
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.restitution = 0.0
        bird.zPosition = 51
        addChild(bird)
        
        let texture1 = SKTexture(imageNamed: "waterflap2copy@2x")
        let texture2 = SKTexture(imageNamed: "waterflap1copy@2x")
        let texture3 = SKTexture(imageNamed: "waterflap3copy@2x")
        
        let textures = [texture1, texture2, texture3]
        
        bird.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1)))
    }
    
    func convert(_ point: CGPoint)->CGPoint {
        return self.view!.convert(CGPoint(x: point.x, y:self.view!.frame.height-point.y), to:self)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        delta = (last_update_time == 0.0) ? 0.0 : currentTime - last_update_time
        last_update_time = currentTime
        
        if state != .fsGameStateEnded {
            moveBackground()
            
            let velocity_x = bird.physicsBody?.velocity.dx
            let velocity_y = bird.physicsBody?.velocity.dy
            
            if bird.physicsBody?.velocity.dy > 280 {
                bird.physicsBody?.velocity = CGVector(dx: velocity_x!, dy: 280)
            }
            
            bird.zRotation = Float.clamp(min: -0.6
                , max: 0.6, value: velocity_y! * (velocity_y < 0 ? 0.003 : 0.001))
        } else {
            bird.zRotation = CGFloat(Double.pi)
            bird.removeAllActions()
        }
        func showAds() {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showadsID"), object: nil)
        }
        func hideAds() {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "hideadsID"), object: nil)
        }
    }
}
