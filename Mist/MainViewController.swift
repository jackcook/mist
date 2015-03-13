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
        
        Places.autocomplete("new j", completion: { (data, error) -> Void in
            let json = JSON(data: data)
            for prediction in json["predictions"].array! {
                println(prediction["description"])
            }
        })
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("new york city", completionHandler: { (placemarks, error) -> Void in
            for p in placemarks {
                let placemark = p as CLPlacemark
                println("\(placemark.location.coordinate.latitude), \(placemark.location.coordinate.longitude)")
            }
        })
    }
}
