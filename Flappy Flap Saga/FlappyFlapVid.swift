//  FlappyFlapVid.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/9/15.
//  Copyright (c) 2015 TechYes. All rights reserved.
//

import AVFoundation
import UIKit
import AVKit

class FlappyFlapVid: UIViewController {
    
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var playerTimer = Timer()
    
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(false)

        let fileURL = URL(fileURLWithPath:  Bundle.main.path(forResource: "output_u7Cbt3", ofType: "mp4")!)
        playerView = AVPlayer(url: fileURL)
        
        playerViewController.player = playerView
        
        playerViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250)
        self.present(playerViewController, animated: false){
            self.playerViewController.showsPlaybackControls = false
            self.playerViewController.player!.play()

            self.playerTimer = Timer.scheduledTimer(timeInterval: 4.2, target: self, selector:#selector(FlappyFlapVid.stopAfter4seconds(_:)), userInfo: nil, repeats: false)
        }
    }
    
    func stopAfter4seconds(_ timer: Timer){
        playerViewController.player?.pause()
        playerViewController.player = nil
        bill().viewDidDisappear(false)
        
    }

    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
}

class  bill {
    func viewDidDisappear(_ animated: Bool){
        
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "GameViewController1") as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = gameScene
    }
}
