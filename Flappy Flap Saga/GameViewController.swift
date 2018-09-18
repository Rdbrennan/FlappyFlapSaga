//
//  GameViewController.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/9/15.
//  Copyright (c) 2015 TechYes. All rights reserved.
//

import UIKit
import SpriteKit
import Social
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate, GADNativeExpressAdViewDelegate {
    
    @IBOutlet var skView: SKView!
    @IBOutlet var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-7491515922135955/3293877028"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        skView.showsFPS = true
        skView.showsNodeCount = true

        if skView.scene == nil {
            let scene = GameScene(size: skView.bounds.size)
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
