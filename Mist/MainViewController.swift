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
    @IBOutlet var locationName: UILabel!
    @IBOutlet var unitButton: UIButton!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pageControlBackground: UIView!
    
    var forecast: ForecastAPI!
    var photos: [Photo]!
    var firstImage: UIImage!
    
    var currentPhoto = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = pageControlBackground.backgroundColor
        
        /*Places.autocomplete("new york", completion: { (data, error) -> Void in
            let json = JSON(data: data)
            for prediction in json["predictions"].array! {
                println(prediction["description"])
            }
        })*/
        
        self.imageView.image = firstImage
        let timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "newPhoto", userInfo: nil, repeats: true)
    }
    
    func loadData(forecast: ForecastAPI, photos: [Photo], firstImage: UIImage) {
        self.forecast = forecast
        self.photos = photos
        self.firstImage = firstImage
    }
    
    func newPhoto() {
        Mozart.load(photos[currentPhoto].imageURL()).completion { (image) -> Void in
            self.imageView.image = image.stackBlur(10)
        }
        
        currentPhoto += 1
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
