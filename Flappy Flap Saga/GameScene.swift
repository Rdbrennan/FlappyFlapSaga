//
//  GameScene.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/9/15.
//  Copyright (c) 2015 TechYes. All rights reserved.
//

import SpriteKit
import AVFoundation
import iAd
import Social
import UIKit

// Math helpers
extension Float {
    static func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if (value > max) {
            return max
        } else if (value < min) {
            return min
        } else {
            return value
        }
    }
    
    static func range(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
}

extension CGFloat {
    func degrees_to_radians() -> CGFloat {
        return CGFloat(Double.pi) * self / 180.0
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate, ADBannerViewDelegate {
    
    //Ad Banner
    var Banner: ADBannerView!
    
    // Bird
    var bird: SKSpriteNode!
    
    // Background
    var background: SKNode!
    let background_speed = 125.0
    
    // Score
    var score = 0
    var highscore = 0
    var label_score: SKLabelNode!
    var label_highscore: SKLabelNode!
    
    // Instructions
    var instructions: SKSpriteNode!
    
    // ReadyText
    var ready: SKSpriteNode!
    
    //Sun Icon
    var sunIcon: SKSpriteNode!
    var sunIcon2: SKSpriteNode!
    
    //Gamover Text
    var gameover: SKSpriteNode!
    
    //New score Label
    var newLabel: SKSpriteNode!
    
    //Bronze Medal
    var BronzeMedal: SKSpriteNode!
    
    //Silver Medal
    var SilverMedal: SKSpriteNode!
    
    //Gold Medal
    var GoldMedal: SKSpriteNode!
    
    //Rainbow Medal
    var RainbowMedal: SKSpriteNode!
    
    //PlayGameButton
    var playButton: SKSpriteNode!
    
    //MenuButton
    var menuButton: SKSpriteNode!
    
    //ScoreButton
    var scoreButton: SKSpriteNode!
    
    // Pipe Origin
    let pipe_origin_x: CGFloat = 382.0
    
    // Floor height
    let floor_distance: CGFloat = 110.0
    
    // Time Values
    var delta = TimeInterval(0)
    var last_update_time = TimeInterval(0)
    
    // Physics Categories
    let FSBoundaryCategory: UInt32 = 1 << 0
    let FSPlayerCategory: UInt32   = 1 << 1
    let FSPipeCategory: UInt32     = 1 << 2
    let FSGapCategory: UInt32      = 1 << 3
    
    
    // GameSounds \\
    
    //wing
    var wingAudio = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sfx_wing", ofType: "mp3")!)
    var wingaudioplayer = AVAudioPlayer()
    
    //hit
    var hitAudio = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sfx_hit", ofType: "mp3")!)
    var hitaudioplayer = AVAudioPlayer()
    
    //point
    var pointAudio = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sfx_point", ofType: "mp3")!)
    var pointaudioplayer = AVAudioPlayer()
    
    //die
    var dieAudio = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sfx_die", ofType: "mp3")!)
    var dieaudioplayer = AVAudioPlayer()
    
    
    
    // Game States
    enum FSGameState: Int {
        case FSGameStateStarting
        case FSGameStatePlaying
        case FSGameStateEnded
    }
    
    var state = FSGameState.FSGameStateStarting
    
    // MARK: - SKScene Initializacion
    override func didMove(to view: SKView) {
        initWorld()
        initBackground()
        initBird()
        initHUD()
        
        wingaudioplayer = try! AVAudioPlayer(contentsOf: wingAudio as URL)
        hitaudioplayer = try! AVAudioPlayer(contentsOf: hitAudio as URL)
        pointaudioplayer = try! AVAudioPlayer(contentsOf: pointAudio as URL)
        dieaudioplayer = try! AVAudioPlayer(contentsOf: dieAudio as URL)
        
        
        
        let highscoreDefault = UserDefaults.standard
        
        if(highscoreDefault.value(forKey: "highscore") != nil){
        highscore = highscoreDefault.value(forKey: "highscore") as! NSInteger!
        label_highscore.text = "\(highscore)"
        
        }
        
    }
    
    // MARK: - Init Physics
    func initWorld() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0.0, y: floor_distance, width: size.width, height: size.height - floor_distance))
        physicsBody?.categoryBitMask = FSBoundaryCategory
        physicsBody?.collisionBitMask = FSPlayerCategory
    }
    
    // MARK: - Init Bird
    func initBird() {
        bird = SKSpriteNode(imageNamed: "waterflap1copy@2x")
        self.bird.position = convert(point: CGPoint(x:157, y:350))
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2.5)
        bird.physicsBody?.categoryBitMask = FSPlayerCategory
        bird.physicsBody?.contactTestBitMask = FSPipeCategory | FSGapCategory | FSBoundaryCategory
        bird.physicsBody?.collisionBitMask = FSPipeCategory | FSBoundaryCategory
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.restitution = 0.0
        bird.zPosition = 51
        addChild(bird)
        
        let texture1 = SKTexture(imageNamed: "waterflap1copy@2x")
        let texture2 = SKTexture(imageNamed: "waterflap2copy@2x")
        let texture3 = SKTexture(imageNamed: "waterflap3copy@2x")
        
        let textures = [texture1, texture2, texture3]
        
        bird.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1)))
    }
    
    // MARK: - Score
    func initHUD() {
        
        label_score = SKLabelNode(fontNamed:"Futura-CondensedExtraBold")
        label_score.fontColor = UIColor.blue
        label_score.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        label_score.text = "0"
        label_score.zPosition = 101
        self.addChild(label_score)
        
        label_highscore = SKLabelNode(fontNamed:"Futura-CondensedExtraBold")
        label_highscore.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        label_highscore.text = "0"
        label_highscore.zPosition = 101
        self.addChild(label_highscore)
        label_highscore.isHidden = true
        
        instructions = SKSpriteNode(imageNamed: "TapToStart")
        self.instructions.position = convert(point: CGPoint(x:157, y:242))
        instructions.zPosition = 50
        addChild(instructions)
        
        ready = SKSpriteNode(imageNamed: "GetReadyText")
        self.ready.position = convert(point: CGPoint(x:157, y:385))
        ready.zPosition = 50
        addChild(ready)
        
    }
    
    // MARK: - Background Functions
    func initBackground() {
        background = SKNode()
        addChild(background)
        
        sunIcon = SKSpriteNode(imageNamed: "Sun-icon")
        self.sunIcon.position = convert(point: CGPoint(x:157, y:350))
        sunIcon.zPosition = 49
        addChild(sunIcon)
        
        
        sunIcon2 = SKSpriteNode(imageNamed: "sun-icon2")
        self.sunIcon2.position = convert(point: CGPoint(x:157, y:151))
        sunIcon2.zPosition = 49
        addChild(sunIcon2)
        
        
        for i in 0...10{
            let tile1 = SKSpriteNode(imageNamed: "background2")
            tile1.anchorPoint = CGPoint.zero
            tile1.size.height = self.size.height
            tile1.position = CGPoint(x: CGFloat(i) * 640.0, y: 0.0)
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
    
    // MARK: - Pipes Functions
    func initPipes() {
        let screenSize = UIScreen.main.bounds
        let isWideScreen = (screenSize.height > 480)
        let bottom = getPipeWithSize(size: CGSize(width: 48, height: Float.range(min: 40, max: isWideScreen ? 360 : 280)), side: false)
        bottom.position = convert(CGPoint(x: pipe_origin_x, y: frame.minY + bottom.size.height/2 + floor_distance), to: background)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.size)
        bottom.physicsBody?.categoryBitMask = FSPipeCategory;
        bottom.physicsBody?.contactTestBitMask = FSPlayerCategory;
        bottom.physicsBody?.collisionBitMask = FSPlayerCategory;
        bottom.physicsBody?.isDynamic = false
        bottom.zPosition = 50
        background.addChild(bottom)
        
        let threshold = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 10, height: 100))
        threshold.position = convert(CGPoint(x: pipe_origin_x, y: floor_distance + bottom.size.height + threshold.size.height/2), to: background)
        threshold.physicsBody = SKPhysicsBody(rectangleOf: threshold.size)
        threshold.physicsBody?.categoryBitMask = FSGapCategory
        threshold.physicsBody?.contactTestBitMask = FSPlayerCategory
        threshold.physicsBody?.collisionBitMask = 0
        threshold.physicsBody?.isDynamic = false
        threshold.zPosition = 50
        background.addChild(threshold)
        
        let topSize = size.height - bottom.size.height - threshold.size.height - floor_distance
        let top = getPipeWithSize(size: CGSize(width: 48 , height: topSize), side: true)
        top.position = convert(CGPoint(x: pipe_origin_x, y: frame.maxY - top.size.height/2), to: background)
        top.physicsBody = SKPhysicsBody(rectangleOf: top.size)
        top.physicsBody?.categoryBitMask = FSPipeCategory;
        top.physicsBody?.contactTestBitMask = FSPlayerCategory;
        top.physicsBody?.collisionBitMask = FSPlayerCategory;
        top.physicsBody?.isDynamic = false
        top.zPosition = 50
        background.addChild(top)
    }
    
    func getPipeWithSize(size: CGSize, side: Bool) -> SKSpriteNode {
        let textureSize = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()

        context?.draw(#imageLiteral(resourceName: "pipezz.png").cgImage!, in: textureSize)
        let tiledBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let backgroundTexture = SKTexture(cgImage: (tiledBackground!.cgImage!))
        let pipe = SKSpriteNode(texture: backgroundTexture)
        pipe.zPosition = 1
        
        let cap = SKSpriteNode(imageNamed: "cap")
        cap.position = CGPoint(x: 0.0, y: side ? -pipe.size.height/2 + cap.size.height/2 : pipe.size.height/2 - cap.size.height/2)
        cap.zPosition = 1
        pipe.addChild(cap)
        
        if side {
            let angle:CGFloat = 180.0
            cap.zRotation = angle.degrees_to_radians()
        }
        return pipe
    }
    
    // MARK: - Game Over helpers
    func gameOver() {
        state = .FSGameStateEnded
        bird.physicsBody?.categoryBitMask = 0
        bird.physicsBody?.collisionBitMask = FSBoundaryCategory
        SKAction.hide()
        
        gameover = SKSpriteNode(imageNamed: "FlappyGameOver")
        gameover.position = CGPoint(x: frame.midX - 3, y: frame.maxY - 265)
        gameover.zPosition = 51
        addChild(gameover)
        
        playButton = SKSpriteNode(imageNamed: "PlayButton")
        playButton.position = CGPoint(x: frame.midX, y: frame.maxY - 430)
        playButton.zPosition = 51
        addChild(playButton)
        
        scoreButton = SKSpriteNode(imageNamed: "ScoreLogo")
        scoreButton.position = CGPoint(x: frame.midX + 80, y: frame.maxY - 363)
        scoreButton.zPosition = 51
        addChild(scoreButton)
        
        menuButton = SKSpriteNode(imageNamed: "Flappymenu")
        menuButton.position = CGPoint(x: frame.midX - 80, y: frame.maxY - 363)
        menuButton.zPosition = 51
        addChild(menuButton)
        
        label_score.fontColor = UIColor.white
        label_score.position = CGPoint(x: frame.midX + 75, y: frame.maxY - 268)
        label_score.zPosition = 101
        
        
        label_highscore.isHidden = false
        label_highscore.position = CGPoint(x: frame.midX + 75, y: frame.maxY - 312)
        label_highscore.zPosition = 101
        
        
        let highscoreDefault = UserDefaults.standard
        highscoreDefault.setValue(highscore, forKey: "highscore")
        highscoreDefault.synchronize()
        
        
        if (score >= highscore){
            newLabel = SKSpriteNode(imageNamed: "New_Score_label")
            newLabel.position = CGPoint(x: frame.midX + 35, y: frame.maxY - 275)
            newLabel.zPosition = 51
            addChild(newLabel)
        }
        
        if(score >= 10)
        {
            BronzeMedal = SKSpriteNode(imageNamed: "BronzeMedal")
            BronzeMedal.position = CGPoint(x: frame.midX - 65, y: frame.maxY - 275)
            BronzeMedal.zPosition = 51
            addChild(BronzeMedal)
        }
        
        
        if(score >= 20)
        {
            SilverMedal = SKSpriteNode(imageNamed: "SilverMedal")
            SilverMedal.position = CGPoint(x: frame.midX - 65, y: frame.maxY - 275)
            SilverMedal.zPosition = 51
            addChild(SilverMedal)
        }
        
        if(score >= 30)
        {
            GoldMedal = SKSpriteNode(imageNamed: "GoldMedal")
            GoldMedal.position = CGPoint(x: frame.midX - 65, y: frame.maxY - 275)
            GoldMedal.zPosition = 51
            addChild(GoldMedal)
        }
        
        if(score >= 40)
        {
            RainbowMedal = SKSpriteNode(imageNamed: "RainbowMedal")
            RainbowMedal.position = CGPoint(x: frame.midX - 65, y: frame.maxY - 275)
            RainbowMedal.zPosition = 51
            addChild(RainbowMedal)
        }
    }
    
    func restartGame() {
        state = .FSGameStateStarting
        bird.removeFromParent()
        background.removeAllChildren()
        background.removeFromParent()
        
        playButton.isHidden = true
        menuButton.isHidden = true
        scoreButton.isHidden = true
        instructions.isHidden = false
        ready.isHidden = false
        gameover.isHidden = true
        label_highscore.isHidden = true
        
        if (score >= highscore){
            newLabel.isHidden = true
        }
        
        
        
        if(score >= 10)
        {
            BronzeMedal.isHidden = true
        }
        
        
        if(score >= 20)
        {
            SilverMedal.isHidden = true
        }
        
        if(score >= 30)
        {
            GoldMedal.isHidden = true
            
        }
        
        if(score >= 40)
        {
            RainbowMedal.isHidden = true
            
        }
        
        removeAction(forKey: "generator")
        
        score = 0
        label_score.fontColor = UIColor.blue
        label_score.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        label_score.text = "0"
        label_score.zPosition = 101
        
        initBird()
        initBackground()
    }
    
    // MARK: - SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)
        
        if collision == (FSPlayerCategory | FSGapCategory) {
            score += 1
            label_score.text = "\(score)"
            pointaudioplayer.play()
            
            if (score >= highscore){
                highscore = score
                label_highscore.text = "\(highscore)"
            }
        }
        
        if collision == (FSPlayerCategory | FSPipeCategory) {
            hitaudioplayer.play()
            dieaudioplayer.play()
                gameOver()
        }
        
        if collision == (FSPlayerCategory | FSBoundaryCategory) {
            if bird.position.y < 150 {
                hitaudioplayer.play()
                dieaudioplayer.play()
                gameOver()
            }
        }
    }
    
    // MARK: - Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .FSGameStateStarting {
            state = .FSGameStatePlaying
            
            instructions.isHidden = true
            ready.isHidden = true
            bird.physicsBody?.affectedByGravity = true
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 25))
            wingaudioplayer.play()
            
            
            run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.run {
                self.initPipes()
                }])), withKey: "generator")
            
        } else if state == .FSGameStatePlaying {
            wingaudioplayer.play()
            
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 25))
        }
        else
        {
            for touch: AnyObject in touches {
                // Get the location of the touch in this scene
                let location = touch.location(in: self);

                // Check if the location of the touch is within the button's bounds
                
                if playButton.contains(location) {
                    restartGame()
                }
                if menuButton.contains(location){
                    self.removeAllChildren()
                    self.removeAllActions()
                    self.scene?.removeFromParent()
                    let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "GameViewController1") as UIViewController
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    appDelegate.window?.rootViewController = gameScene

                }
                if scoreButton.contains(location){
                    self.removeAllChildren()
                    self.removeAllActions()
                    self.scene?.removeFromParent()
                    let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "HighScoreController") as UIViewController
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    appDelegate.window?.rootViewController = gameScene
                }
            }
        }
    }
    
    func convert(point: CGPoint)->CGPoint {
        return self.view!.convert(CGPoint(x: point.x, y:self.view!.frame.height-point.y), to:self)
    }
    
    // MARK: - Frames Per Second
    override func update(_ currentTime: CFTimeInterval) {
        delta = (last_update_time == 0.0) ? 0.0 : currentTime - last_update_time
        last_update_time = currentTime
        
        if state != .FSGameStateEnded {
            moveBackground()
            
            let velocity_x = bird.physicsBody!.velocity.dx
            let velocity_y = bird.physicsBody!.velocity.dy
            
            if (bird.physicsBody?.velocity.dy)! > CGFloat (280) {
                self.bird.physicsBody?.velocity = CGVector(dx: velocity_x, dy: 280)
            }
            
            bird.zRotation = Float.clamp(min: -0.6
                , max: 0.6, value: velocity_y * (velocity_y < 0 ? 0.003 : 0.001))
        } else {
            bird.zRotation = CGFloat(Double.pi)
            bird.removeAllActions()
            removeAction(forKey: "generator")

        }
        func showAds() {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showadsID"), object: nil)
        }
        func hideAds() {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideadsID"), object: nil)
        }
    }
}
