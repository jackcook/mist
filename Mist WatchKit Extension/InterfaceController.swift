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
        
        let locations = ["Hourly", "New York, NY", "San Francisco, CA", "Toronto, CA", "Chicago, IL", "Dallas, TX"]
        var rowTypes = [String]()
        
        for location in locations {
            if location == "Hourly" {
                rowTypes.append("HeaderRow")
            } else {
                rowTypes.append("HourlyRow")
            }
        }
        
//        tableView.setNumberOfRows(locations.count, withRowType: "HourlyRow")
        tableView.setRowTypes(rowTypes)
        
        for i in 0...tableView.numberOfRows - 1 {
            let row: AnyObject? = tableView.rowControllerAtIndex(i)
            
            if row is HeaderRow {
                let headerRow = row as HeaderRow
                headerRow.headerLabel.setText("Hourly")
            } else {
                let hourlyRow = row as HourlyRow
                hourlyRow.timeLabel.setText("1 PM")
            }
//            let name = locations[i]
//            
//            if name == "Hourly" {
//                let row = tableView.rowControllerAtIndex(i) as HeaderRow
//                row.headerLabel.setText(name)
//            } else {
//                let row = tableView.rowControllerAtIndex(i) as HourlyRow
//                row.timeLabel.setText("1 PM")
//            }
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
