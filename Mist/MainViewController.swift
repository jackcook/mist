//
//  MainViewController.swift
//  Mist
//
//  Created by Jack Cook on 3/12/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import CoreLocation
import SwiftyJSON
import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Places.autocomplete("guel", completion: { (data, error) -> Void in
            let json = JSON(data: data)
            for prediction in json["predictions"].array! {
                println(prediction["description"])
            }
        })
        
        ForecastAPI.getCurrentConditions("guelph", completion: { (forecast, error) -> Void in
            println(forecast.current.nearestStormDistance)
        })
    }
}
