//
//  Places.swift
//  Mist
//
//  Created by Jack Cook on 3/13/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Places {
    
    class func autocomplete(string: String, completion: (results: [String], error: NSError?) -> Void) {
        let input = string.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(Keys.googlePlacesKey())&input=\(input)&types=(cities)"
        request(.GET, url).responseJSON { (_, _, json, error) -> Void in
            let json = JSON(json!)
            var results = [String]()
            if let predictions = json["predictions"].array {
                for prediction in predictions {
                    if let description = prediction["description"].string {
                        results.append(description)
                    }
                }
            }
            
            completion(results: results, error: error)
        }
    }
}
