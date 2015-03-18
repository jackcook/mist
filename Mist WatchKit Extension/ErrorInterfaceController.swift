//
//  ErrorInterfaceController.swift
//  Mist
//
//  Created by Jack Cook on 3/18/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import WatchKit

class ErrorInterfaceController: WKInterfaceController {
    
    var timer: NSTimer!
    
    override func awakeWithContext(context: AnyObject?) {
        self.setTitle("")
    }
    
    override func willActivate() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkForData", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func checkForData() {
        let defaults = NSUserDefaults(suiteName: "group.nyc.jackcook.Mist")
        
        if let done = defaults?.boolForKey("DoneLoading") {
            if done {
                self.dismissController()
                timer.invalidate()
            }
        }
    }
}
