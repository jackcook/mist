//
//  Google.swift
//  Mist
//
//  Created by Jack Cook on 3/14/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Alamofire
import Foundation

class Google {
    
    class func getImage(lat: Float, lon: Float, completion: (image: UIImage) -> Void) {
        let lat = lat + (Float(arc4random_uniform(20)) / 1000.0 - 0.01)
        let lon = lon + (Float(arc4random_uniform(20)) / 1000.0 - 0.01)
        
        let heading = Int(arc4random_uniform(360))
        
        let url = "https://maps.googleapis.com/maps/api/streetview?size=1000x600&location=\(lat),\(lon)&fov=90&heading=\(heading)&pitch=10&key=\(Keys.googleImagesKey())"
        
        Mozart.load(url).completion { (image) -> Void in
            completion(image: image)
        }
    }
}
