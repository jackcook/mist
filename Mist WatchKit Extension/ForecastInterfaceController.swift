//
//  ForecastInterfaceController.swift
//  Mist WatchKit Extension
//
//  Created by Jack Cook on 3/17/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import WatchKit
import Foundation

class ForecastInterfaceController: WKInterfaceController {
    
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    @IBOutlet var weatherImage: WKInterfaceImage!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    @IBOutlet var tableView: WKInterfaceTable!
    
    var weatherData: [String: AnyObject]!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var rowTypes = [String]()
        var forecastTypes = [String]()
        
        if let data = context as? [String: AnyObject] {
            self.weatherData = data
            
            if let name = data["name"] as? String {
                self.nameLabel.setText(name)
            }
        }
        
        rowTypes.append("HeaderRow")
        forecastTypes.append("Header")
        
        let hourlyData = self.weatherData["hourly"] as [[String: AnyObject]]
        for hour in hourlyData {
            rowTypes.append("ForecastRow")
            forecastTypes.append("Hourly")
        }
        
        rowTypes.append("HeaderRow")
        forecastTypes.append("Header")
        
        let dailyData = self.weatherData["daily"] as [[String: AnyObject]]
        for day in dailyData {
            rowTypes.append("ForecastRow")
            forecastTypes.append("Daily")
        }
        
        tableView.setRowTypes(rowTypes)
        
        var hourlyDone = false
        for i in 0...tableView.numberOfRows - 1 {
            let row: AnyObject? = tableView.rowControllerAtIndex(i)
            
            if row is HeaderRow {
                let headerRow = row as HeaderRow
                headerRow.headerLabel.setText(hourlyDone ? "Daily" : "Hourly")
                hourlyDone = true
            } else {
                let forecastRow = row as ForecastRow
                
                if forecastTypes[i] == "Hourly" {
                    let hourData = hourlyData[i - 1] as [String: AnyObject]
                    
//                    let hour = hourData["hour"]! as String
                    let hour = "5PM"
                    forecastRow.timeLabel.setText(hour)
                    
                    let temp = hourData["temperature"]! as Float
                    forecastRow.temperatureLabel.setText("\(Int(temp))º")
                    
                    let desc = hourData["description"]! as String
                    forecastRow.descriptionLabel.setText(desc)
                } else if forecastTypes[i] == "Daily" {
                    let dayData = dailyData[i - hourlyData.count - 2] as [String: AnyObject]
                    
                    let day = dayData["day"]! as String
                    forecastRow.timeLabel.setText(day.uppercaseString)
                    
                    let high = dayData["high"]! as Float
                    let low = dayData["low"]! as Float
                    forecastRow.temperatureLabel.setText("\(Int(high))º/\(Int(low))º")
                    
                    let desc = dayData["description"]! as String
                    forecastRow.descriptionLabel.setText(desc)
                }
            }
        }
    }

    override func willActivate() {
        super.willActivate()
    }
}
