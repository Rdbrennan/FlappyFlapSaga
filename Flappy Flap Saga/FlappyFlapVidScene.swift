//  FlappyFlapIntro.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/12/15.
//  Copyright © 2015 TechYes. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FlappyFlapVidScene: UIViewController {
    
    private var firstAppear = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            do {
                try playVideo()
                firstAppear = false
            } catch AppError.InvalidResource(let name, let type) {
                debugPrint("Could not find resource \(name).\(type)")
            } catch {
                debugPrint("Generic error")
            }
            
        }
    }
    
    private func playVideo() throws {
        guard let path = NSBundle.mainBundle().pathForResource("output_aV7ELO", ofType:".mp4") else {
            throw AppError.InvalidResource("output_aV7ELO", ".mp4")
        }
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
}

enum AppError : ErrorType {
    case InvalidResource(String, String)
}