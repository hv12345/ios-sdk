//
//  AppDelegate.swift
//  HyperSecureDocsParentApp
//
//  Created by Srinija on 27/02/18.
//  Copyright © 2018 hyperverge. All rights reserved.
//

import UIKit
import HyperSnapSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        HyperSnapDemoAppLocalizer.DoTheSwizzling()
        
        //SDK Initialization Step
        HyperSnapSDKConfig.initialize(appId: Global.shared.appID, appKey: Global.shared.appKey, region: Global.shared.region)
        
        HyperSnapSDKConfig.setShouldUseSignature(true)
        
        return true
    }



}

