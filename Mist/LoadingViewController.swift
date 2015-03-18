//
//  LoadingViewController.swift
//  Mist
//
//  Created by Jack Cook on 3/12/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import StackBluriOS
import SwiftyJSON
import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet var background: UIImageView!
    @IBOutlet var imageView: UIImageView!
    
    var imageTimer: NSTimer!
    var currentImage = 0
    var animationFinished = false
    var finishedRequests = 0
    var totalRequests = 2
    
    var locations = ["New York, NY", "San Francisco, CA"]
    var forecasts = [ForecastAPI]()
    var photos: [Photo]!
    var firstImage: UIImage!
    
    var weatherData = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "Background-01")?.stackBlur(85)
        background.image = backgroundImage
        
        loadForecasts()
        loadImages()
        
        imageTimer = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: "updateLoader", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(imageTimer, forMode: NSRunLoopCommonModes)
    }
    
    func loadForecasts() {
        for location in locations {
            totalRequests += 1
            
            ForecastAPI.getCurrentConditions(location, completion: { (forecast, error) -> Void in
                self.forecasts.append(forecast)
                self.finishedRequests += 1
                
                var weatherObject = [String: AnyObject]()
                weatherObject["name"] = location
                
                var hourlyObjects = [[String: AnyObject]]()
                var dailyObjects = [[String: AnyObject]]()
                
                var i = 0
                for hourly in forecast.hourly.forecast {
                    if i == 0 || i % 3 == 0 {
                        var hourlyObject = [String: AnyObject]()
                        
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "ha"
                        hourlyObject["hour"] = formatter.stringFromDate(hourly.time)
                        hourlyObject["icon"] = hourly.icon
                        hourlyObject["temperature"] = hourly.temperature
                        hourlyObject["description"] = hourly.summary
                        
                        hourlyObjects.append(hourlyObject)
                    }
                    
                    i += 1
                    
                    if i >= 12 {
                        break
                    }
                }
                
                i = 0
                for daily in forecast.daily.forecast {
                    var dailyObject = [String: AnyObject]()
                    
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "EEE"
                    dailyObject["day"] = formatter.stringFromDate(daily.time)
                    dailyObject["icon"] = daily.icon
                    dailyObject["high"] = daily.temperatureMax
                    dailyObject["low"] = daily.temperatureMin
                    dailyObject["description"] = daily.summary
                    
                    dailyObjects.append(dailyObject)
                    
                    i += 1
                    
                    if i >= 3 {
                        break
                    }
                }
                
                weatherObject["hourly"] = hourlyObjects
                weatherObject["daily"] = dailyObjects
                
                self.weatherData.append(weatherObject)
                
                self.finish()
            })
        }
    }
    
    func loadImages() {
        Flickr.getPhoto("New York, NY") { (photos) -> Void in
            self.photos = photos
            self.finishedRequests += 1
            self.finish()
            
            Mozart.load(self.photos[0].imageURL()).completion { (image) -> Void in
                self.firstImage = image.stackBlur(10)
                self.finishedRequests += 1
                self.finish()
            }
        }
    }
    
    func finish() {
        if (finishedRequests == totalRequests) && animationFinished {
            let defaults = NSUserDefaults(suiteName: "group.nyc.jackcook.Mist")
            defaults?.setObject(weatherData, forKey: "WeatherData")
            println(weatherData)
            
            self.performSegueWithIdentifier("mainSegue", sender: self)
            imageTimer.invalidate()
        }
    }
    
    func updateLoader() {
        let imageName = NSString(format: "%05d", currentImage)
        let image = UIImage(named: imageName)
        imageView.image = image
        
        currentImage += 1
        
        if currentImage == 150 {
            currentImage = 0
            animationFinished = true
            finish()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mvc = segue.destinationViewController as MainViewController
        mvc.loadData(forecasts, photos: photos, firstImage: firstImage)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
