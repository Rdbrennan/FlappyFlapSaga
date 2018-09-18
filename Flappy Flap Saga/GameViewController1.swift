//  GameViewController1.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/9/15.
//  Copyright (c) 2015 TechYes. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import Social

class GameViewController1: UIViewController {

    @IBOutlet var skView: SKView!
    var Banner: ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if skView.scene == nil {
            let scene = FlappyFlapIntro(size: skView.bounds.size)
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
    
    @IBAction func facebookBtn(_ sender: AnyObject) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    
}
