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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = bottomView.backgroundColor
        
        Places.autocomplete("big sky", completion: { (data, error) -> Void in
            let json = JSON(data: data)
            for prediction in json["predictions"].array! {
//                println(prediction["description"])
            }
        })
        
        ForecastAPI.getCurrentConditions("Big Sky, MT", completion: { (forecast, error) -> Void in
//            println(forecast.current.temperature)
        })
        
//        newPhoto()
//        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "newPhoto", userInfo: nil, repeats: true)
//        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func newPhoto() {
        Google.getImage(40.720032, lon: -73.988354) { (image) -> Void in
            self.imageView.image = image
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ForecastCell", forIndexPath: indexPath) as UITableViewCell
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
