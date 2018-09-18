//
//  FacebookShare.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 12/14/15.
//  Copyright © 2015 TechYes. All rights reserved.
//

import UIKit
import Social

class FacebookShare: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    
    }

}
