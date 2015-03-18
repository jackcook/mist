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
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var pageControlBackground: UIView!
    
    var currentForecast = 0
    var forecasts: [ForecastAPI]!
    var photos: [Photo]!
    var firstImage: UIImage!
    
    var currentPhoto = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = pageControlBackground.backgroundColor
        
        self.pageControl.numberOfPages = self.forecasts.count
        
//        self.imageView.image = firstImage
//        let timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "newPhoto", userInfo: nil, repeats: true)
        
        let slgr = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        slgr.direction = .Left
        self.view.addGestureRecognizer(slgr)
        
        let srgr = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        srgr.direction = .Right
        self.view.addGestureRecognizer(srgr)
    }
    
    func swipeLeft() {
        changeLocation(true)
    }
    
    func swipeRight() {
        changeLocation(false)
    }
    
    func changeLocation(next: Bool) {
        if (next && currentForecast == forecasts.count - 1) || (!next && currentForecast == 0) {
            return
        }
        
        currentForecast += next ? 1 : -1
        self.pageControl.currentPage = currentForecast
        
        let nextLocation = self.forecasts[currentForecast]
        
        self.locationName.text = nextLocation.current.summary
    }
    
    func loadData(forecasts: [ForecastAPI], photos: [Photo], firstImage: UIImage) {
        self.forecasts = forecasts
//        self.photos = photos
//        self.firstImage = firstImage
    }
    
    func loadData(forecasts: [ForecastAPI]) {
        self.forecasts = forecasts
    }
    
    func newPhoto() {
        Mozart.load(photos[currentPhoto].imageURL()).completion { (image) -> Void in
            self.imageView.image = image.stackBlur(10)
        }
        
        currentPhoto += 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts[currentForecast].hourly.forecast.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ForecastCell", forIndexPath: indexPath) as UITableViewCell
        
        let hour = forecasts[currentForecast].hourly.forecast[indexPath.row]
        
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
