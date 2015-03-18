//
//  MainInterfaceController.swift
//  Mist
//
//  Created by Jack Cook on 3/17/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import WatchKit

class MainInterfaceController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    
    override func willActivate() {
        let locations = ["New York, NY", "San Francisco, CA", "Toronto, CA", "Chicago, IL", "Dallas, TX"]
        let defaults = NSUserDefaults(suiteName: "group.nyc.jackcook.Mist")
        let weatherData = defaults?.objectForKey("WeatherData")
        
        tableView.setNumberOfRows(locations.count, withRowType: "LocationRow")
        
        for i in 0...tableView.numberOfRows - 1 {
            let row = tableView.rowControllerAtIndex(i) as LocationRow
            row.locationName.setText(locations[i])
        }
    }
}
