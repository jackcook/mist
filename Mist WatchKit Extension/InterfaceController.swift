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
    
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    @IBOutlet var weatherImage: WKInterfaceImage!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    @IBOutlet var tableView: WKInterfaceTable!
    
    var weatherData: [String: AnyObject]!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var rowTypes = [String]()
        
        if let data = context as? [String: AnyObject] {
            self.weatherData = data
            
            if let name = data["name"] as? String {
                self.nameLabel.setText(name)
            }
        }
        
        rowTypes.append("HeaderRow")
        
        let hourlyData = self.weatherData["hourly"] as [[String: AnyObject]]
        for hour in hourlyData {
            rowTypes.append("HourlyRow")
        }
        
        rowTypes.append("HeaderRow")
        
        tableView.setRowTypes(rowTypes)
        
        for i in 0...tableView.numberOfRows - 1 {
            let row: AnyObject? = tableView.rowControllerAtIndex(i)
            
            if row is HeaderRow {
                let headerRow = row as HeaderRow
                headerRow.headerLabel.setText("Hourly")
            } else {
                let hourlyRow = row as HourlyRow
                
                let hour = hourlyData[i]["hour"]!
                hourlyRow.timeLabel.setText("\(hour)")
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
