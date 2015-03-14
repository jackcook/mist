//
//  Forecast.swift
//  Mist
//
//  Created by Jack Cook on 3/13/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Alamofire
import CoreLocation
import Foundation
import SwiftyJSON

class Forecast: NSObject {
    
    class func getCurrentConditions(place: String, completion: (data: NSData, error: NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(place, completionHandler: { (placemarks, error) -> Void in
            let coordinate = (placemarks[0] as CLPlacemark).location.coordinate
            self.getCurrentConditions(coordinate, completion: { (data, error) -> Void in
                completion(data: data, error: error)
            })
        })
    }
    
    class func getCurrentConditions(coordinate: CLLocationCoordinate2D, completion: (data: NSData, error: NSError?) -> Void) {
        let url = "https://api.forecast.io/forecast/\(Keys.forecastKey())/\(coordinate.latitude),\(coordinate.longitude)"
        request(.GET, url).response { (_, _, data, error) -> Void in
            completion(data: data as NSData, error: error)
        }
    }
    
    var latitude: Float!
    var longitude: Float!
    var timezone: String!
    var offset: Float!
    var current: CurrentConditions!
    var minutely: MinutelyConditions!
    var hourly: HourlyConditions!
    var daily: DailyConditions!
    
    init(data: NSData) {
        let json = JSON(data: data)
    }
}

class CurrentConditions: NSObject {
    
}

class MinutelyConditions: NSObject {
    
}

class HourlyConditions: NSObject {
    
}

class DailyConditions: NSObject {
    
}
