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
    
    var weatherData: Array<Dictionary<String, AnyObject>>!
    
    override func willActivate() {
        let defaults = NSUserDefaults(suiteName: "group.nyc.jackcook.Mist")
        self.weatherData = defaults?.arrayForKey("WeatherData") as [[String: AnyObject]]
        
        tableView.setNumberOfRows(self.weatherData.count, withRowType: "LocationRow")
        
        for i in 0...tableView.numberOfRows - 1 {
            let row = tableView.rowControllerAtIndex(i) as LocationRow
            let data = self.weatherData[i]
            let name = data["name"] as String
            row.locationName.setText(name)
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return self.weatherData[rowIndex]
    }
}
