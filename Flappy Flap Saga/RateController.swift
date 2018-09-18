//
//  RateController.swift
//  Flappy Flap Saga
//
//  Created by Robert Brennan on 11/20/15.
//  Copyright © 2015 TechYes. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class RateController: UIViewController, GADNativeExpressAdViewDelegate {
    
    @IBOutlet var nativeView: GADNativeExpressAdView!

    
    /*override func loadView() {
        let request2 = GADRequest()
        request2.testDevices = [kGADSimulatorID]
        nativeView.delegate = self
        nativeView.adUnitID = "ca-app-pub-2986180897672051/5005975724"
        nativeView.rootViewController = self
        nativeView.load(request2)
        

                }*/
}

    func rateApp(){
    UIApplication.shared.openURL(URL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(1061308314)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!);
        
}
