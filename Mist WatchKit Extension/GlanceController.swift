//
//  GlanceController.swift
//  Mist WatchKit Extension
//
//  Created by Jack Cook on 3/17/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet var topGroup: WKInterfaceGroup!
    @IBOutlet var weatherImage: WKInterfaceImage!
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    @IBOutlet var noticeLabel: WKInterfaceLabel!
    @IBOutlet var locationLabel: WKInterfaceLabel!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    
    var timer: NSTimer!
    var weatherData: [[String: AnyObject]]!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let defaults = NSUserDefaults(suiteName: "group.nyc.jackcook.Mist")
        if let wd = defaults?.arrayForKey("WeatherData") as? [[String: AnyObject]] {
            self.weatherData = wd
            self.loadContent()
        } else {
            self.topGroup.setHidden(true)
            self.noticeLabel.setHidden(false)
            self.locationLabel.setHidden(true)
            self.descriptionLabel.setHidden(true)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkForData", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func loadContent() {
        self.topGroup.setHidden(false)
        self.noticeLabel.setHidden(true)
        self.locationLabel.setHidden(false)
        self.descriptionLabel.setHidden(false)
        
        let data = self.weatherData[0]
        self.weatherImage.setImageNamed("Snow")
        
        let temperature = data["temperature"] as Float
        self.temperatureLabel.setText("\(Int(temperature))º")
        
        let location = data["name"] as String
        self.locationLabel.setText(location)
        
        let description = data["description"] as String
        self.descriptionLabel.setText(description.lowercaseString)
        
        if WKInterfaceDevice.currentDevice().screenBounds.width < 156 {
            self.weatherImage.setWidth(64)
            self.weatherImage.setHeight(48)
            
            let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(38), NSForegroundColorAttributeName: UIColor(red: 0.35, green: 0.71, blue: 0.95, alpha: 1)]
            let attributedString = NSAttributedString(string: "\(Int(temperature))º", attributes: attributes)
            self.temperatureLabel.setAttributedText(attributedString)
        }
    }
    
    func checkForData() {
        let defaults = NSUserDefaults(suiteName: "group.nyc.jackcook.Mist")
        
        if let done = defaults?.boolForKey("DoneLoading") {
            if done {
                timer.invalidate()
                
                if let wd = defaults?.arrayForKey("WeatherData") as? [[String: AnyObject]] {
                    self.weatherData = wd
                    self.loadContent()
                }
            }
        }
    }
}
