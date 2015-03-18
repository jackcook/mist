//
//  LoadingInterfaceController.swift
//  Mist
//
//  Created by Jack Cook on 3/18/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import WatchKit

class LoadingInterfaceController: WKInterfaceController {
    
    var results: [String]!
    
    override func awakeWithContext(context: AnyObject?) {
        self.setTitle("")
        self.results = context as [String]
    }
    
    override func willActivate() {
        WKInterfaceController.openParentApplication(["results": results], reply: { (data, error) -> Void in
            self.pushControllerWithName("VerifyInterfaceController", context: data)
        })
    }
}
