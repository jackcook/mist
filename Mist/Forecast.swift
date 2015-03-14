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

class ForecastAPI: NSObject {
    
    class func getCurrentConditions(place: String, completion: (forecast: ForecastAPI, error: NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(place, completionHandler: { (placemarks, error) -> Void in
            let coordinate = (placemarks[0] as CLPlacemark).location.coordinate
            self.getCurrentConditions(coordinate, completion: { (forecast, error) -> Void in
                completion(forecast: forecast, error: error)
            })
        })
    }
    
    class func getCurrentConditions(coordinate: CLLocationCoordinate2D, completion: (forecast: ForecastAPI, error: NSError?) -> Void) {
        let url = "https://api.forecast.io/forecast/\(Keys.forecastKey())/\(coordinate.latitude),\(coordinate.longitude)?units=us&extend=hourly"
        request(.GET, url).response { (_, _, data, error) -> Void in
            let forecast = ForecastAPI(data: data as NSData)
            completion(forecast: forecast, error: error)
        }
    }
    
    var latitude: Float!
    var longitude: Float!
    var timezone: String!
    var offset: Float!
    var current: Conditions!
    var minutely: Forecast!
    var hourly: Forecast!
    var daily: Forecast!
    
    init(data: NSData) {
        let json = JSON(data: data)
        
        self.latitude = json["latitude"].float
        self.longitude = json["longitude"].float
        self.timezone = json["timezone"].string
        self.offset = json["offset"].float
        
        if let currently = json["currently"].dictionaryObject {
            let conditions = Conditions(json: currently)
            self.current = conditions
        }
        
        if let minutely = json["minutely"].dictionary {
            let forecast = Forecast(json: minutely)
            self.minutely = forecast
        }
        
        if let hourly = json["hourly"].dictionary {
            let forecast = Forecast(json: hourly)
            self.hourly = forecast
        }
        
        if let daily = json["daily"].dictionary {
            let forecast = Forecast(json: daily)
            self.daily = forecast
        }
    }
}

class Forecast: NSObject {
    
    var summary: String!
    var icon: String!
    var forecast = [Conditions]()
    
    init(json: Dictionary<String, JSON>) {
        super.init()
        
        self.summary = json["summary"]?.stringValue
        self.icon = json["icon"]?.stringValue
        
        if let data = json["data"]?.arrayValue {
            for conditions in data {
                let conditionsObject = Conditions(json: conditions.dictionaryObject!)
                self.forecast.append(conditionsObject)
            }
        }
    }
}

class Conditions: NSObject {
    
    // Minute
    var time: NSDate!
    var precipIntensity: Int!
    var precipProbability: Int!
    
    // Current, Hourly
    var summary: String!
    var icon: String!
    var dewPoint: Float!
    var humidity: Float!
    var windSpeed: Float!
    var windBearing: Int!
    var visibility: Float!
    var cloudCover: Int!
    var pressure: Float!
    var ozone: Float!
    
    var nearestStormDistance: Int!
    var nearestStormBearing: Int!
    var temperature: Float!
    var apparentTemperature: Float!
    
    // Daily
    var sunriseTime: NSDate!
    var sunsetTime: NSDate!
    var moonPhase: Float!
    var temperatureMin: Float!
    var temperatureMinTime: NSDate!
    var temperatureMax: Float!
    var temperatureMaxTime: NSDate!
    var apparentTemperatureMin: Float!
    var apparentTemperatureMinTime: NSDate!
    var apparentTemperatureMax: Float!
    var apparentTemperatureMaxTime: NSDate!
    
    init(json: Dictionary<String, AnyObject>) {
        super.init()
        
        if let timestamp = json["time"]?.integerValue {
            let referenceDate = NSTimeInterval(timestamp)
            self.time = NSDate(timeIntervalSinceReferenceDate: referenceDate)
        }
        
        self.precipIntensity = json["precipIntensity"]?.integerValue
        self.precipProbability = json["precipProbability"]?.integerValue
        
        if let summary = json["summary"] as? String {
            self.summary = summary
        }
        
        if let icon = json["icon"] as? String {
            self.icon = icon
        }
        
        self.dewPoint = json["dewPoint"]?.floatValue
        self.humidity = json["humidity"]?.floatValue
        self.windSpeed = json["windSpeed"]?.floatValue
        self.windBearing = json["windBearing"]?.integerValue
        self.visibility = json["visibility"]?.floatValue
        self.cloudCover = json["cloudCover"]?.integerValue
        self.pressure = json["pressure"]?.floatValue
        
        self.nearestStormDistance = json["nearestStormDistance"]?.integerValue
        self.nearestStormBearing = json["nearestStormBearing"]?.integerValue
        self.temperature = json["temperature"]?.floatValue
        self.apparentTemperature = json["apparentTemperature"]?.floatValue
        
        if let timestamp = json["sunriseTime"]?.integerValue {
            let referenceDate = NSTimeInterval(timestamp)
            self.sunriseTime = NSDate(timeIntervalSinceReferenceDate: referenceDate)
        }
        
        if let timestamp = json["sunsetTime"]?.integerValue {
            let referenceDate = NSTimeInterval(timestamp)
            self.sunsetTime = NSDate(timeIntervalSinceReferenceDate: referenceDate)
        }
        
        self.moonPhase = json["moonPhase"]?.floatValue
        self.temperatureMin = json["temperatureMin"]?.floatValue
        self.temperatureMax = json["temperatureMax"]?.floatValue
        self.apparentTemperatureMin = json["apparentTemperatureMin"]?.floatValue
        self.apparentTemperatureMax = json["apparentTemperatureMax"]?.floatValue
        
        if let timestamp = json["temperatureMinTime"]?.integerValue {
            let referenceDate = NSTimeInterval(timestamp)
            self.temperatureMinTime = NSDate(timeIntervalSinceReferenceDate: referenceDate)
        }
        
        if let timestamp = json["temperatureMaxTime"]?.integerValue {
            let referenceDate = NSTimeInterval(timestamp)
            self.temperatureMaxTime = NSDate(timeIntervalSinceReferenceDate: referenceDate)
        }
        
        if let timestamp = json["apparentTemperatureMaxTime"]?.integerValue {
            let referenceDate = NSTimeInterval(timestamp)
            self.apparentTemperatureMaxTime = NSDate(timeIntervalSinceReferenceDate: referenceDate)
        }
        
        if let timestamp = json["apparentTemperatureMaxTime"]?.integerValue {
            let referenceDate = NSTimeInterval(timestamp)
            self.apparentTemperatureMinTime = NSDate(timeIntervalSinceReferenceDate: referenceDate)
        }
    }
}
