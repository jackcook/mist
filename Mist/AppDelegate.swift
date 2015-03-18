//
//  AppDelegate.swift
//  Mist
//
//  Created by Jack Cook on 3/12/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Crashlytics
import Fabric
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        return true
    }
    
    func application(application: UIApplication!, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]!, reply: (([NSObject : AnyObject]!) -> Void)!) {
        if let voiceResults = userInfo["results"] as? [String] {
            Places.autocomplete(voiceResults[0], completion: { (results, error) -> Void in
                println(results)
                reply(["results": results])
            })
        } else if let city = userInfo["load"] as? String {
            ForecastAPI.getCurrentConditions(city, completion: { (forecast, error) -> Void in
                ForecastAPI.loadToDefaults(forecast)
                reply(["done": true])
            })
        }
    }
}
