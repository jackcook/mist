//
//  Places.swift
//  Mist
//
//  Created by Jack Cook on 3/13/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Alamofire

class Places {
    
    class func autocomplete(string: String, completion: (data: NSData, error: NSError?) -> Void) {
        let input = string.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(Keys.googlePlacesKey())&input=\(input)&types=(cities)"
        request(.GET, url).response { (_, _, data, error) -> Void in
            completion(data: data as NSData, error: error)
        }
    }
}
