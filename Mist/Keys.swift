//
//  Keys.swift
//  Mist
//
//  Created by Jack Cook on 3/12/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

class Keys {
    
    class func forecastKey() -> String {
        return Keys.getKey("Forecast")
    }
    
    class func googlePlacesKey() -> String {
        return Keys.getKey("GooglePlaces")
    }
    
    class func getKey(key: String) -> String {
        let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: path) as [String: String]
        
        return dict[key]!
    }
}
