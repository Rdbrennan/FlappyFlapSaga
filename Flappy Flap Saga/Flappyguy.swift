//
//  Flappyguy.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/26/15.
//  Copyright © 2015 TechYes. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FlappyGuy: UIViewController {
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewDidAppear(animated:Bool) {
        var fileURL = NSURL(fileURLWithPath: "/Users/robertbrennan/Desktop/Flappy Flap Saga/Flappy Flap Saga/Intro Vid/output_u7Cbt3.mp4")
        
        playerView = AVPlayer(URL: fileURL)
        
        playerViewController.player = playerView
        
        self.presentViewController(playerViewController, animated: true){
            self.playerViewController.player?.play()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
}