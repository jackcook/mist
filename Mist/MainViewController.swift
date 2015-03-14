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

class MainViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Places.autocomplete("big sky", completion: { (data, error) -> Void in
            let json = JSON(data: data)
            for prediction in json["predictions"].array! {
//                println(prediction["description"])
            }
        })
        
        ForecastAPI.getCurrentConditions("Big Sky, MT", completion: { (forecast, error) -> Void in
//            println(forecast.current.temperature)
        })
        
        Flickr.getPhoto("new york", lat: 40.7127, lon: 74.0059) { (photos) -> Void in
            for photo in photos {
                println(photo.imageURL())
            }
        }
    }
}
