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
    
    var weatherData: [[String: AnyObject]]!
    
    override func willActivate() {
        let defaults = NSUserDefaults(suiteName: "group.nyc.jackcook.Mist")
        if let wd = defaults?.arrayForKey("WeatherData") as? [[String: AnyObject]] {
            self.weatherData = wd
            loadLocations()
        } else {
            self.presentControllerWithName("ErrorInterfaceController", context: nil)
        }
    }
    
    func loadLocations() {
        var rowTypes = [String]()
        
        for location in self.weatherData {
            rowTypes.append("LocationRow")
        }
        
        rowTypes.append("CreateRow")
        
        tableView.setRowTypes(rowTypes)
        
        for i in 0...tableView.numberOfRows - 1 {
            let row: AnyObject? = tableView.rowControllerAtIndex(i)
            
            if row is LocationRow {
                let row = tableView.rowControllerAtIndex(i) as LocationRow
                let data = self.weatherData[i]
                let name = data["name"] as String
                row.locationName.setText(name)
            } else if row is CreateRow {
                let row = tableView.rowControllerAtIndex(i) as CreateRow
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if rowIndex == table.numberOfRows - 1 {
            self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: .Plain) { (results) -> Void in
                if results != nil {
                    let context = results
                    self.presentControllerWithName("VerifyInterfaceController", context: context)
                }
            }
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return self.weatherData[rowIndex]
    }
}
