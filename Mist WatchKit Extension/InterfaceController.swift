//
//  InterfaceController.swift
//  Mist WatchKit Extension
//
//  Created by Jack Cook on 3/17/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var weatherImage: WKInterfaceImage!
    @IBOutlet var tableView: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let defaults = NSUserDefaults(suiteName: "group.nyc.jackcook.Mist")
        println(defaults?.objectForKey("test"))
        
        let locations = ["New York, NY", "San Francisco, CA", "Toronto, CA", "Chicago, IL", "Dallas, TX"]
        
        tableView.setNumberOfRows(locations.count, withRowType: "HourlyRow")
        
        for i in 0...tableView.numberOfRows - 1 {
            let row = tableView.rowControllerAtIndex(i) as HourlyRow
            row.timeLabel.setText("1 PM")
        }
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
