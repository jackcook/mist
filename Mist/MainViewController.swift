//
//  MainViewController.swift
//  Mist
//
//  Created by Jack Cook on 3/12/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Alamofire
import CoreLocation
import SwiftyJSON
import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var bottomView: UIView!
    
    var forecast: ForecastAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.backgroundColor = bottomView.backgroundColor
        
        Places.autocomplete("big sky", completion: { (data, error) -> Void in
            let json = JSON(data: data)
            for prediction in json["predictions"].array! {
//                println(prediction["description"])
            }
        })
        
        ForecastAPI.getCurrentConditions("new york", completion: { (forecast, error) -> Void in
            self.forecast = forecast
            
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })
        
        newPhoto()
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "newPhoto", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func newPhoto() {
        Google.getImage(40.720032, lon: -73.988354) { (image) -> Void in
            let img = image.stackBlur(25)
            self.imageView.image = img
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.hourly.forecast.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ForecastCell", forIndexPath: indexPath) as UITableViewCell
        
        let hour = forecast.hourly.forecast[indexPath.row]
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh"
        
        let hourLabel = cell.contentView.viewWithTag(10) as UILabel
        hourLabel.text = formatter.stringFromDate(hour.time)
        
        formatter.dateFormat = "a"
        
        let ampmLabel = cell.contentView.viewWithTag(11) as UILabel
        ampmLabel.text = formatter.stringFromDate(hour.time)
        
        let temperatureLabel = cell.contentView.viewWithTag(13) as UILabel
        temperatureLabel.text = "\(Int(hour.temperature)) º"
        
        let summaryLabel = cell.contentView.viewWithTag(14) as UILabel
        summaryLabel.text = hour.summary
        
        let windLabel = cell.contentView.viewWithTag(16) as UILabel
        windLabel.text = "\(Int(hour.windSpeed)) mph"
        
        let precipitationLabel = cell.contentView.viewWithTag(18) as UILabel
        precipitationLabel.text = "\(hour.precipProbability) %"
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
