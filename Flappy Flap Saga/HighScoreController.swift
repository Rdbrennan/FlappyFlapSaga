//
//  HighScoreController.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/9/15.
//  Copyright (c) 2015 TechYes. All rights reserved.
//

import UIKit
import SpriteKit
import Social

class HighScoreController: UIViewController {
    
    @IBOutlet var skView: SKView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if skView.scene == nil {
            let scene = HighScoreScene(size: skView.bounds.size)
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
