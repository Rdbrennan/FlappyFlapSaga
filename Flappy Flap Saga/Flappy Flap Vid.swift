//  GameViewController1.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/9/15.
//  Copyright (c) 2015 TechYes. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

class GameViewController2: UIViewController, ADBannerViewDelegate {
    
    @IBOutlet var skView: SKView!
    var Banner: ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        if skView.scene == nil {
            let scene = FlappyFlapIntro(size: skView.bounds.size)
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("Error!")
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        Banner.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}